//
//  GetStoresUseCaseImpl.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import Foundation

struct GetStoresUseCaseImpl: GetStoresUseCase {
    
    let repository: StoreRepository
    
    func execute(
        types: [CertificationType]
    ) -> [Store] {
        return repository.getStores(types: types)
    }
    
}
