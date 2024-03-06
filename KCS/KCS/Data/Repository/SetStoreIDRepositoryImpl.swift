//
//  SetStoreIDRepositoryImpl.swift
//  KCS
//
//  Created by 김영현 on 3/3/24.
//

import Foundation

struct SetStoreIDRepositoryImpl: SetStoreIDRepository {
    
    let storage: StoreIDStorage
    
    func setStoreID(id: Int) {
        storage.storeID = id
    }
    
}
