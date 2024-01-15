//
//  GetStoresUseCaseImpl.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import Foundation

struct GetStoresUseCaseImpl: GetStoresUseCase {
    
    let repository: StoreRepository
    
    init(repository: StoreRepository) {
        self.repository = repository
    }
    
    func execute(
        type: CertificationType
    ) -> [Store] {
        return repository.getStores(type: type)
    }
    
}