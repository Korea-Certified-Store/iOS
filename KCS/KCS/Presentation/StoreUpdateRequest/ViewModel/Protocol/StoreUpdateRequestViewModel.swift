//
//  StoreUpdateRequestViewModel.swift
//  KCS
//
//  Created by 조성민 on 2/17/24.
//

import RxRelay
import RxSwift

protocol StoreUpdateRequestViewModel: StoreUpdateRequestViewModelInput, StoreUpdateRequestViewModelOutput {
    
    var dependency: StoreUpdateRequestDepenency { get }
    
}

protocol StoreUpdateRequestViewModelInput {
    
    func action(input: StoreUpdateRequestViewModelInputCase)
    
}

enum StoreUpdateRequestViewModelInputCase {
    
    case setStoreID(id: Int)
    case typeInput(text: String)
    case contentEndEditing(text: String)
    case contentWhileEditing(text: String)
    case completeButtonIsEnable(type: String, content: String)
    case storeUpdateRequest(type: String, content: String)
    
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
    var completeRequestOutput: PublishRelay<Void> { get }
    var errorAlertOutput: PublishRelay<ErrorAlertMessage> { get }
    
}

struct StoreUpdateRequestDepenency {
    
    let storeUpdateRequestUseCase: StoreUpdateRequestUseCase
    let fetchStoreIDUseCase: FetchStoreIDUseCase
    let setStoreIDUseCase: SetStoreIDUseCase
    let disposeBag = DisposeBag()
    
}
