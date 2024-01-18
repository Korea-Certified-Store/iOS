//
//  GetFilteredStoresUseCaseImpl.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import Foundation

struct GetFilteredStoresUseCaseImpl: GetFilteredStoresUseCase {
    
    let repository: StoreRepository
    
    init(repository: StoreRepository) {
        self.repository = repository
    }
    
    func execute(
        filters: [CertificationType]
    ) -> [FilteredStores] {
        var goodPriceStores = FilteredStores(
            type: .goodPrice,
            stores: []
        )
        var exemplaryStores = FilteredStores(
            type: .exemplary,
            stores: []
        )
        var safeStores = FilteredStores(
            type: .safe,
            stores: []
        )
        
        let stores = repository.getStores(types: filters)
        stores.forEach { store in
            var type: CertificationType?
            filters.forEach { filter in
                if store.certificationTypes.contains(filter) {
                    type = filter
                }
            }
            if let checkedType = type {
                switch checkedType {
                case .goodPrice:
                    goodPriceStores.stores.append(store)
                case .exemplary:
                    exemplaryStores.stores.append(store)
                case .safe:
                    safeStores.stores.append(store)
                }
            }
        }
        
        return [goodPriceStores, exemplaryStores, safeStores]
    }
    
}
