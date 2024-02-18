//
//  FetchStoreIDRepositoryImpl.swift
//  KCS
//
//  Created by 조성민 on 2/18/24.
//

import RxSwift

final class FetchStoreIDRepositoryImpl: FetchStoreIDRepository {
    
    let storage: StoreIDStorage
    
    init(storage: StoreIDStorage) {
        self.storage = storage
    }
    
    func fetchStoreID() -> Int? {
        return storage.storeID
    }
    
}
