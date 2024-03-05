//
//  StubFailureFetchStoreIDUseCase.swift
//  KCSUnitTest
//
//  Created by 조성민 on 3/6/24.
//

import Foundation
@testable import KCS

struct StubFailureFetchStoreIDUseCase: FetchStoreIDUseCase {
    
    let repository: FetchStoreIDRepository
    
    init(repository: FetchStoreIDRepository = FetchStoreIDRepositoryImpl(storage: StoreIDStorage())) {
        self.repository = repository
    }
    
    func execute() -> Int? {
        return nil
    }
    
}
