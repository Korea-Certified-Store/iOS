//
//  SummaryInformationViewModelImpl.swift
//  KCS
//
//  Created by 김영현 on 1/18/24.
//

import RxSwift
import RxRelay

final class SummaryInformationViewModelImpl: SummaryInformationViewModel {
    
    private let disposeBag = DisposeBag()
    
    let getOpenClosedUseCase: GetOpenClosedUseCase
    let fetchImageUseCase: FetchImageUseCase
    
    var openClosedOutput = PublishRelay<OpenClosedType>()
    var openingHourOutput = PublishRelay<String>()
    var thumbnailImageOutput = PublishRelay<Data>()
    
    init(getOpenClosedUseCase: GetOpenClosedUseCase, fetchImageUseCase: FetchImageUseCase) {
        self.getOpenClosedUseCase = getOpenClosedUseCase
        self.fetchImageUseCase = fetchImageUseCase
    }
    
    func action(input: SummaryInformationViewInputCase) {
        switch input {
        case .setOpenClosed(let openingHour):
            setOpenClosed(openingHour: openingHour)
        case .setOpeningHour(let openingHour):
            setOpeningHour(openingHour: openingHour)
        case .fetchThumbnailImage(let url):
            fetchThumbnailImage(url: url)
        }
    }
    
}

private extension SummaryInformationViewModelImpl {
    
    func setOpenClosed(
        openingHour: [RegularOpeningHours]
    ) {
        openClosedOutput.accept(getOpenClosedUseCase.execute(openingHours: openingHour))
    }
    
    func setOpeningHour(
        openingHour: [RegularOpeningHours]
    ) {
        openingHourOutput.accept(openingHourString(openingHour: openingHour))
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

private extension SummaryInformationViewModelImpl {
    
    func openingHourString(openingHour: [RegularOpeningHours]) -> String {
        let openHours = openingHour.filter({ $0.open.day.index == Date().weekDay })
        if openHours.isEmpty { return "" }
        
        var openingHourStrings: [String] = []
        if let openHour = openHours.first?.open.hour,
           let openMin = openHours.first?.open.minute {
            openingHourStrings.append(String(format: "%02d:%02d", openHour, openMin))
        }
        if let closeHour = openHours.last?.close.hour,
           let closeMin = openHours.last?.close.minute {
            if closeHour == 0 {
                openingHourStrings.append(String(format: "%02d:%02d", 24, closeMin))
            } else {
                openingHourStrings.append(String(format: "%02d:%02d", closeHour, closeMin))
            }
        }
        
        return openingHourStrings.joined(separator: " - ")
    }
    
}
