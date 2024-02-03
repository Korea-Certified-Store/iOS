//
//  SummaryViewModel.swift
//  KCS
//
//  Created by 김영현 on 1/18/24.
//

import RxSwift
import RxRelay

protocol SummaryViewModel: SummaryViewModelInput, SummaryViewModelOutput {
    
    var getOpenClosedUseCase: GetOpenClosedUseCase { get }
    var fetchImageUseCase: FetchImageUseCase { get }
    
}

enum SummaryViewInputCase {
    
    case setUIContents(
        store: Store
    )
    
}

protocol SummaryViewModelInput {
    
    func action(input: SummaryViewInputCase)
    
}

protocol SummaryViewModelOutput {
    
    var setUIContentsOutput: PublishRelay<SummaryViewContents> { get }
    var thumbnailImageOutput: PublishRelay<Data> { get }
    var callButtonOutput: PublishRelay<String> { get }
    var errorAlertOutput: PublishRelay<ErrorAlertMessage> { get }
    
}
