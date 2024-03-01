//
//  MockGetStoresRepository.swift
//  KCSUnitTest
//
//  Created by 김영현 on 3/1/24.
//

import Foundation
@testable import KCS

struct MockGetStoresRepository: GetStoresRepository {
    
    var storeStorage: StoreStorage
    
    func getStores() -> [Store] {
        return []
    }
    
}
