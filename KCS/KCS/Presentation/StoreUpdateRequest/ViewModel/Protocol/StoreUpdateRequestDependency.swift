//
//  StoreUpdateRequestDependency.swift
//  KCS
//
//  Created by 김영현 on 2/20/24.
//

import RxSwift

struct StoreUpdateRequestDepenency {
    
    let storeUpdateRequestUseCase: StoreUpdateRequestUseCase
    let fetchStoreIDUseCase: FetchStoreIDUseCase
    let setStoreIDUseCase: SetStoreIDUseCase
    
}
