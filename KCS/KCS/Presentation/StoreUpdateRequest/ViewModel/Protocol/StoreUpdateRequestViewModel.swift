//
//  StoreUpdateRequestViewModel.swift
//  KCS
//
//  Created by 조성민 on 2/17/24.
//

import RxRelay

protocol StoreUpdateRequestViewModel: StoreUpdateRequestViewModelInput, StoreUpdateRequestViewModelOutput {
    
}

protocol StoreUpdateRequestViewModelInput {
    
    func action(input: StoreUpdateRequestViewModelInputCase)
    
}

enum StoreUpdateRequestViewModelInputCase {
    
    case typeInput(text: String)
    case contentInput(text: String)
    
}

protocol StoreUpdateRequestViewModelOutput {
    
    var typeWarningOutput: PublishRelay<Void> { get }
    var typeEditEndOutput: PublishRelay<Void> { get }
    var contentWarningOutput: PublishRelay<Void> { get }
    var contentEditEndOutput: PublishRelay<Void> { get }
    
}
