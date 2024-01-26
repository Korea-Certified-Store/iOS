//
//  SummaryViewModel.swift
//  KCS
//
//  Created by 김영현 on 1/18/24.
//

import RxSwift
import RxRelay

protocol SummaryViewModel: SummaryInformationViewModelInput, SummaryInformationViewModelOutput {
    
    var getOpenClosedUseCase: GetOpenClosedUseCase { get }
    var fetchImageUseCase: FetchImageUseCase { get }
    
}

enum SummaryInformationViewInputCase {
    
    case setUIContents(
        store: Store
    )
    
}

protocol SummaryInformationViewModelInput {
    
    func action(input: SummaryInformationViewInputCase)
    
}

protocol SummaryInformationViewModelOutput {
    
    var setUIContentsOutput: PublishRelay<SummaryViewContents> { get }
    var thumbnailImageOutput: PublishRelay<Data> { get }
    
}
