//
//  StubFetchStoreIDUseCase.swift
//  KCSUnitTest
//
//  Created by 조성민 on 3/5/24.
//

import Foundation
@testable import KCS

struct StubSuccessFetchStoreIDUseCase: FetchStoreIDUseCase {
    
    let repository: FetchStoreIDRepository
    
    init(repository: FetchStoreIDRepository = FetchStoreIDRepositoryImpl(storage: StoreIDStorage())) {
        self.repository = repository
    }
    
    func execute() -> Int? {
        return StoreUpdateRequestViewModelImplTestsConstant.fetchStoreIDUseCaseResult
    }
    
}

struct StubFailureFetchStoreIDUseCase: FetchStoreIDUseCase {
    
    let repository: FetchStoreIDRepository
    
    init(repository: FetchStoreIDRepository = FetchStoreIDRepositoryImpl(storage: StoreIDStorage())) {
        self.repository = repository
    }
    
    func execute() -> Int? {
        return nil
    }
    
}
