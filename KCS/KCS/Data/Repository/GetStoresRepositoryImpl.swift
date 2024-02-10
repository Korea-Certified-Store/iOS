//
//  GetStoresRepositoryImpl.swift
//  KCS
//
//  Created by 김영현 on 2/11/24.
//

import Foundation

final class GetStoresRepositoryImpl: GetStoresRepository {
    
    let storeStorage: StoreStorage
    
    init(storeStorage: StoreStorage) {
        self.storeStorage = storeStorage
    }
    
    func getStores() -> [Store] {
        return storeStorage.stores
    }
    
}
