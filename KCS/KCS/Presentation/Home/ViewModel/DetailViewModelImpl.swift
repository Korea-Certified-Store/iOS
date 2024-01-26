//
//  DetailViewModelImpl.swift
//  KCS
//
//  Created by 조성민 on 1/24/24.
//

import RxSwift
import RxRelay

final class DetailViewModelImpl: DetailViewModel {
    
    private let disposeBag = DisposeBag()
    
    let getOpenClosedUseCase: GetOpenClosedUseCase
    let fetchImageUseCase: FetchImageUseCase
    
    var setUIContentsOutput = PublishRelay<DetailViewContents>()
    var thumbnailImageOutput = PublishRelay<Data>()
    
    init(getOpenClosedUseCase: GetOpenClosedUseCase, fetchImageUseCase: FetchImageUseCase) {
        self.getOpenClosedUseCase = getOpenClosedUseCase
        self.fetchImageUseCase = fetchImageUseCase
    }
    
    func action(input: DetailViewModelInputCase) {
        switch input {
        case .setUIContents(let store):
            setUIContents(store: store)
        }
    }
    
}

private extension DetailViewModelImpl {
    
    func setUIContents(store: Store) {
        setUIContentsOutput.accept(
            DetailViewContents(
                storeTitle: store.title,
                category: store.category,
                certificationTypes: store.certificationTypes,
                address: store.address,
                phoneNumber: store.phoneNumber ?? "전화번호 정보 없음",
                openClosedContent: getOpenClosedUseCase.execute(openingHours: store.openingHour),
                detailOpeningHour: detailOpeningHour(openingHours: store.openingHour)
            )
        )
    }
    
    func fetchThumbnailImage(localPhotos: [String]) {
        guard let url = localPhotos.first else { return }
        fetchImageUseCase.execute(url: url)
            .subscribe(
                onNext: { [weak self] imageData in
                    self?.thumbnailImageOutput.accept(imageData)
                },
                onError: { error in
                    print(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
}

private extension DetailViewModelImpl {
    
    func detailOpeningHour(openingHours: [RegularOpeningHours]) -> [DetailOpeningHour] {
        if openingHours.isEmpty { return [] }
        var detailOpeningHourArray: [DetailOpeningHour] = []
        
        let today = Date().weekDay
        for idx in today..<today + 7 {
            let weekDayIndex = idx % 7 == 0 ? 7 : idx % 7
            if let weekday = Day.allCases.filter({ $0.index == weekDayIndex }).first {
                let openingHours = openingHours.filter { $0.open.day == weekday }
                if openingHours.isEmpty {
                    detailOpeningHourArray.append(
                        DetailOpeningHour(
                            weekDay: weekday,
                            openingHour: OpeningHour(
                                openingHour: OpenClosedType.dayOff.rawValue,
                                breakTime: nil
                            )
                        )
                    )
                }
                
                if openingHours.count == 1 {
                    if let openingHour = openingHours.first {
                        detailOpeningHourArray.append(
                            DetailOpeningHour(
                                weekDay: weekday,
                                openingHour: OpeningHour(
                                    openingHour: openingHourToString(
                                        open: openingHour.open,
                                        close: openingHour.close
                                    ),
                                    breakTime: nil)
                            )
                        )
                    }
                } else {
                    if let firstOpeningHour = openingHours.first,
                       let lastOpeningHour = openingHours.last {
                        if firstOpeningHour.open == lastOpeningHour.close {
                            detailOpeningHourArray.append(
                                DetailOpeningHour(
                                    weekDay: weekday,
                                    openingHour: OpeningHour(
                                        openingHour: openingHourToString(
                                            open: lastOpeningHour.open,
                                            close: firstOpeningHour.close
                                        ),
                                        breakTime: nil
                                    )
                                )
                            )
                        } else {
                            detailOpeningHourArray.append(
                                DetailOpeningHour(
                                    weekDay: weekday,
                                    openingHour: OpeningHour(
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
                                )
                            )
                        }
                    }
                }
            }
        }
        
        return detailOpeningHourArray
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
