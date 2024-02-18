//
//  SetStoreIDUseCaseImpl.swift
//  KCS
//
//  Created by 조성민 on 2/18/24.
//

import Foundation

struct SetStoreIDUseCaseImpl: SetStoreIDUseCase {
    
    let storage: StoreIDStorage
    
    func execute(id: Int) {
        storage.storeID = id
    }
    
}
