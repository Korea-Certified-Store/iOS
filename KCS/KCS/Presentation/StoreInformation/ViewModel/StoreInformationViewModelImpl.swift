//
//  StoreInformationViewModelImpl.swift
//  KCS
//
//  Created by 조성민 on 2/3/24.
//

import RxRelay
import RxSwift

final class StoreInformationViewModelImpl: StoreInformationViewModel {
    
    let dependency: StoreInformationDependency
    private let disposeBag = DisposeBag()
    
    let setDetailUIContentsOutput = PublishRelay<DetailViewContents>()
    let setSummaryUIContentsOutput = PublishRelay<SummaryViewContents>()
    let thumbnailImageOutput = PublishRelay<Data>()
    let summaryCallButtonOutput = PublishRelay<String>()
    let errorAlertOutput = PublishRelay<ErrorAlertMessage>()
    
    init(dependency: StoreInformationDependency) {
        self.dependency = dependency
    }
    
    func action(input: StoreInformationViewModelInputCase) {
        switch input {
        case .setUIContents(let store):
            setUIContents(store: store)
        }
    }
    
}

private extension StoreInformationViewModelImpl {
    
    func setUIContents(store: Store) {
        fetchThumbnailImage(localPhotos: store.localPhotos)
        
        if let phoneNumber = store.phoneNumber {
            summaryCallButtonOutput.accept(phoneNumber)
        }
        
        do {
            let openClosedContent = try dependency.getOpenClosedUseCase.execute(openingHours: store.openingHour)
            setSummaryUIContentsOutput.accept(
                SummaryViewContents(
                    storeTitle: store.title,
                    category: store.category,
                    certificationTypes: store.certificationTypes,
                    openClosedContent: openClosedContent
                )
            )
            setDetailUIContentsOutput.accept(
                DetailViewContents(
                    storeTitle: store.title,
                    category: store.category,
                    certificationTypes: store.certificationTypes,
                    address: store.address,
                    phoneNumber: store.phoneNumber ?? "전화번호 정보 없음",
                    openClosedContent: openClosedContent,
                    detailOpeningHour: detailOpeningHour(openingHours: store.openingHour)
                )
            )
        } catch {
            errorAlertOutput.accept(.client)
        }
    }
    
    func fetchThumbnailImage(localPhotos: [String]) {
        guard let url = localPhotos.first else { return }
        dependency.fetchImageUseCase.execute(url: url)
            .subscribe(
                onNext: { [weak self] imageData in
                    self?.thumbnailImageOutput.accept(imageData)
                },
                onError: { [weak self] _ in
                    self?.errorAlertOutput.accept(.server)
                }
            )
            .disposed(by: disposeBag)
    }
    
}

private extension StoreInformationViewModelImpl {
    
    func detailOpeningHour(openingHours: [RegularOpeningHours]) -> [DetailOpeningHour] {
        if openingHours.isEmpty { return [] }
        var detailOpeningHourArray: [DetailOpeningHour] = []
        
        let today = Date().weekDay
        for idx in today..<today + 7 {
            let weekDayIndex = idx % 7 == 0 ? 7 : idx % 7
            if let weekday = Day.allCases.filter({ $0.index == weekDayIndex }).first {
                let openingHours = openingHours.filter { $0.open.day == weekday }
                detailOpeningHourArray.append(
                    DetailOpeningHour(
                        weekDay: weekday,
                        openingHour: getOpeningHour(
                            openingHours: openingHours
                        )
                    )
                )
            }
        }
        return detailOpeningHourArray
    }
    
    func getOpeningHour(openingHours: [RegularOpeningHours]) -> OpeningHour {
        if openingHours.isEmpty {
            return OpeningHour(
                openingHour: OpenClosedType.dayOff.rawValue,
                breakTime: nil
            )
        }
        
        if openingHours.count == 1 {
            if let openingHour = openingHours.first {
                if openingHour.open == openingHour.close {
                    return OpeningHour(
                        openingHour: OpenClosedType.alwaysOpen.rawValue,
                        breakTime: nil
                    )
                } else {
                    return OpeningHour(
                        openingHour: openingHourToString(
                            open: openingHour.open,
                            close: openingHour.close
                        ),
                        breakTime: nil
                    )
                }
            }
        } else {
            if let firstOpeningHour = openingHours.first,
               let lastOpeningHour = openingHours.last {
                if firstOpeningHour.open == lastOpeningHour.close {
                    return OpeningHour(
                        openingHour: openingHourToString(
                            open: lastOpeningHour.open,
                            close: firstOpeningHour.close
                        ),
                        breakTime: nil
                    )
                } else {
                    return OpeningHour(
                        openingHour: openingHourToString(
                            open: firstOpeningHour.open,
                            close: lastOpeningHour.close
                        ),
                        breakTime: openingHourToString(
                            open: firstOpeningHour.close,
                            close: lastOpeningHour.open,
                            isBreakTime: true
                        )
                    )
                }
            }
        }
        
        return OpeningHour(openingHour: nil, breakTime: nil)
    }
    
    func openingHourToString(open: BusinessHour, close: BusinessHour, isBreakTime: Bool = false) -> String {
        var format = "%02d:%02d - %02d:%02d"
        if isBreakTime {
            format = "%02d:%02d - %02d:%02d 브레이크 타임"
        }
        
        return String(
            format: format,
            open.hour,
            open.minute,
            close.hour,
            close.minute
        )
    }
    
}
