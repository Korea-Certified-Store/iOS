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
    
    func getStores(count: Int) -> [Store] {
        let stores = storeStorage.stores
        if stores.isEmpty { return [] }
        var fetchResult: [Store] = []
        var storeCount = count * 15
        if storeCount > stores.count {
            storeCount = stores.count
        }
        for index in 0..<storeCount {
            fetchResult.append(stores[index])
        }
        return fetchResult
    }
    
}
