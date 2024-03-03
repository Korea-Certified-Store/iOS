//
//  SetStoreIDRepositoryImpl.swift
//  KCS
//
//  Created by 김영현 on 3/3/24.
//

import Foundation

struct SetStoreIDRepositoryImpl: SetStoreIDRepository {
    
    var storage: StoreIDStorage
    
    func fetchStoreID(id: Int) {
        storage.storeID = id
    }
    
}
