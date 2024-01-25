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
    
    var openClosedOutput = PublishRelay<OpenClosedInformation>()
    var thumbnailImageOutput = PublishRelay<Data>()
    
    init(getOpenClosedUseCase: GetOpenClosedUseCase, fetchImageUseCase: FetchImageUseCase) {
        self.getOpenClosedUseCase = getOpenClosedUseCase
        self.fetchImageUseCase = fetchImageUseCase
    }
    
    func action(input: DetailViewModelInputCase) {
        switch input {
        case .setInformationView(let openingHour, let url):
            setOpenClosed(openingHour: openingHour)
            if let url = url {
                fetchThumbnailImage(url: url)
            }
        }
    }
    
}

private extension DetailViewModelImpl {
    
    func setOpenClosed(
        openingHour: [RegularOpeningHours]
    ) {
        openClosedOutput.accept(
            OpenClosedInformation(
                openClosedContent: getOpenClosedUseCase.execute(openingHours: openingHour),
                detailOpeningHour: detailOpeningHour(openingHours: openingHour)
            )
        )
    }
    
    func fetchThumbnailImage(url: String) {
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
    
    func detailOpeningHour(openingHours: [RegularOpeningHours]) -> [Day: OpeningHour] {
        if openingHours.isEmpty { return [:] }
        var openingHourDictionary: [Day: OpeningHour] = [:]
        
        Day.allCases.forEach { day in
            let openingHours = openingHours.filter { $0.open.day == day }
            if openingHours.isEmpty {
                openingHourDictionary[day] = OpeningHour(openingHour: OpenClosedType.dayOff.rawValue, breakTime: nil)
            }
            if openingHours.count == 1 {
                if let openingHour = openingHours.first {
                    openingHourDictionary[day] = OpeningHour(
                        openingHour: openingHourToString(open: openingHour.open, close: openingHour.close),
                        breakTime: nil
                    )
                }
            } else {
                if let firstOpeningHour = openingHours.first,
                   let lastOpeningHour = openingHours.last {
                    if firstOpeningHour.open == lastOpeningHour.close {
                        openingHourDictionary[day] = OpeningHour(
                            openingHour: openingHourToString(open: lastOpeningHour.open, close: firstOpeningHour.close),
                            breakTime: nil
                        )
                    } else {
                        openingHourDictionary[day] = OpeningHour(
                            openingHour: openingHourToString(open: firstOpeningHour.open, close: lastOpeningHour.close),
                            breakTime: openingHourToString(open: firstOpeningHour.close, close: lastOpeningHour.open, isBreakTime: true)
                        )
                    }
                }
            }
        }
        
        return openingHourDictionary
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
