//
//  StubFetchStoreIDRepository.swift
//  KCSUnitTest
//
//  Created by 조성민 on 3/3/24.
//

import Foundation
@testable import KCS

struct StubSuccessFetchStoreIDRepository: FetchStoreIDRepository {
    
    var storage: StoreIDStorage
    
    func fetchStoreID() -> Int? {
        return FetchStoreIDUseCaseImplTestsConstant.successStoreID
    }
    
}

struct StubFailureFetchStoreIDRepository: FetchStoreIDRepository {
    
    var storage: StoreIDStorage
    
    func fetchStoreID() -> Int? {
        return FetchStoreIDUseCaseImplTestsConstant.failureStoreID
    }
    
}
