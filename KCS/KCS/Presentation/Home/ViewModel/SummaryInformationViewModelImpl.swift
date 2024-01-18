//
//  SummaryInformationViewModelImpl.swift
//  KCS
//
//  Created by 김영현 on 1/18/24.
//

import RxSwift
import RxRelay

final class SummaryInformationViewModelImpl: SummaryInformationViewModel {
    
    let getOpenClosedUseCase: GetOpenClosedUseCase
    
    init(getOpenClosedUseCase: GetOpenClosedUseCase) {
        self.getOpenClosedUseCase = getOpenClosedUseCase
    }
    
    var getOpenClosed = PublishRelay<OpenClosedType>()
    var getOpeningHour = PublishRelay<String>()
    
    func isOpenClosed(
        openingHour: [RegularOpeningHours]
    ) {
        getOpenClosed.accept(getOpenClosedUseCase.execute(openingHours: openingHour))
    }
    
    func getOpeningHour(
        openingHour: [RegularOpeningHours]
    ) {
        getOpeningHour.accept(openingHourString(openingHour: openingHour))
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
