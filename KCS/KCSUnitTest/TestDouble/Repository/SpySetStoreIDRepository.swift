//
//  SpySetStoreIDRepository.swift
//  KCSUnitTest
//
//  Created by 김영현 on 3/3/24.
//

import Foundation
@testable import KCS

final class SpySetStoreIDRepository: SetStoreIDRepository {
    
    let storage: StoreIDStorage
    var executeCount: Int = 0
    
    init(storage: StoreIDStorage) {
        self.storage = storage
    }
    
    func fetchStoreID(id: Int) {
        executeCount += 1
    }
    
}
