//
//  FetchStoresUseCaseImpl.swift
//  KCS
//
//  Created by 조성민 on 1/18/24.
//

import Foundation

struct FetchStoresUseCaseImpl: FetchStoresUseCase {
    
    let repository: StoreRepository
    
    init(repository: StoreRepository) {
        self.repository = repository
    }
    
    func execute() -> [Store] {
        return repository.fetchStores()
    }

}
