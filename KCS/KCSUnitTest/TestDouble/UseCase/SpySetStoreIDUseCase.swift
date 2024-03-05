//
//  SpySetStoreIDUseCase.swift
//  KCSUnitTest
//
//  Created by 조성민 on 3/5/24.
//

import Foundation
@testable import KCS

final class SpySetStoreIDUseCase: SetStoreIDUseCase {
    
    let repository: SetStoreIDRepository
    var executeCount: Int = 0
    
    init(repository: SetStoreIDRepository = SetStoreIDRepositoryImpl(storage: StoreIDStorage())) {
        self.repository = repository
    }
    
    func execute(id: Int) {
        executeCount += 1
    }
    
}
