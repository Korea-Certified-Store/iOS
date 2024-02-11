//
//  FetchStoresUseCaseImpl.swift
//  KCS
//
//  Created by 조성민 on 1/18/24.
//

import Foundation

struct FetchStoresUseCaseImpl: FetchStoresUseCase {
    
    let repository: StoreRepository
    
    func execute(fetchCount: Int) -> [Store] {
        return repository.fetchStores(count: fetchCount)
    }

}
