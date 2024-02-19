//
//  NewStoreRequestDependency.swift
//  KCS
//
//  Created by 김영현 on 2/20/24.
//

import RxSwift
import RxRelay

struct NewStoreRequestDependency {
    
    let postNewStoreUseCase: PostNewStoreUseCase
    let disposeBag = DisposeBag()
    let titleEditState = PublishRelay<Bool>()
    let addressEditState = PublishRelay<Bool>()
    let detailAddressEditState = PublishRelay<Bool>()
    let certificationEditState = PublishRelay<Bool>()
    
}
