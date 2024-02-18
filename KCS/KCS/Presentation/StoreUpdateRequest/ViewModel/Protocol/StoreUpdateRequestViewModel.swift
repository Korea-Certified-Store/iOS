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
    case contentEndEditing(text: String)
    case contentWhileEditing(text: String)
    case completeButtonIsEnable(type: String, content: String)
    
}

protocol StoreUpdateRequestViewModelOutput {
    
    var typeWarningOutput: PublishRelay<Void> { get }
    var typeEditEndOutput: PublishRelay<Void> { get }
    var contentWarningOutput: PublishRelay<Void> { get }
    var contentEditEndOutput: PublishRelay<Void> { get }
    var contentErasePlaceHolder: PublishRelay<Void> { get }
    var contentFillPlaceHolder: PublishRelay<Void> { get }
    var contentLengthWarningOutput: PublishRelay<Void> { get }
    var contentLengthNormalOutput: PublishRelay<Void> { get }
    var completeButtonIsEnabledOutput: PublishRelay<Bool> { get }
    
}