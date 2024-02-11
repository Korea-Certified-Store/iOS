//
//  GetRefreshStoresUseCaseImpl.swift
//  KCS
//
//  Created by 조성민 on 1/18/24.
//

import Foundation

struct GetRefreshStoresUseCaseImpl: GetRefreshStoresUseCase {
    
    let repository: GetStoresRepository
    
    func execute(fetchCount: Int) -> [Store] {
        let stores = repository.getStores()
        if stores.isEmpty { return [] }
        
        var fetchResult: [Store] = []
        var storeCount = fetchCount * 15
        if storeCount > stores.count {
            storeCount = stores.count
        }
        for index in 0..<storeCount {
            fetchResult.append(stores[index])
        }
        return fetchResult
    }

}
