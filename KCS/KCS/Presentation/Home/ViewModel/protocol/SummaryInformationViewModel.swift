//
//  SummaryInformationViewModel.swift
//  KCS
//
//  Created by 김영현 on 1/18/24.
//

import RxSwift
import RxRelay

protocol SummaryInformationViewModel: SummaryInformationViewModelInput, SummaryInformationViewModelOutput {
    
    var getOpenClosedUseCase: GetOpenClosedUseCase { get }
    
}

protocol SummaryInformationViewModelInput {
    
    func isOpenClosed(
        openingHour: [RegularOpeningHours]
    )
    
    func getOpeningHour(
        openingHour: [RegularOpeningHours]
    )
    
}

protocol SummaryInformationViewModelOutput {
    
    var getOpeningHour: PublishRelay<String> { get }
    var getOpenClosed: PublishRelay<OpenClosedType> { get }
    
}
