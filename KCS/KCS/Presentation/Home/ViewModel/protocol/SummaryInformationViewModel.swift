//
//  SummaryInformationViewModel.swift
//  KCS
//
//  Created by 김영현 on 1/18/24.
//

import RxSwift
import RxRelay

protocol SummaryInformationViewModel: StoreInformationViewModelInput, StoreInformationViewModelOutput {
    
    var getOpenClosedUseCase: GetOpenClosedUseCase { get }
    var fetchImageUseCase: FetchImageUseCase { get }
    
}

enum StoreInformationViewInputCase {
    
    case setInformationView(
        openingHour: [RegularOpeningHours],
        url: String?
    )
    
}

protocol StoreInformationViewModelInput {
    
    func action(input: StoreInformationViewInputCase)
    
}

protocol StoreInformationViewModelOutput {
    
    var openClosedOutput: PublishRelay<OpenClosedContent> { get }
    var thumbnailImageOutput: PublishRelay<Data> { get }
    
}
