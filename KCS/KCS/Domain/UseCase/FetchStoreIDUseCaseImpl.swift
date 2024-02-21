//
//  FetchStoreIDUseCaseImpl.swift
//  KCS
//
//  Created by 조성민 on 2/18/24.
//

import RxSwift

struct FetchStoreIDUseCaseImpl: FetchStoreIDUseCase {
    
    let repository: FetchStoreIDRepository
    
    func execute() -> Int? {
        return repository.fetchStoreID()
    }
    
}
