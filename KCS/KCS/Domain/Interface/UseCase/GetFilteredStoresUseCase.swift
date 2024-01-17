//
//  GetFilteredStoresUseCase.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import Foundation

protocol GetFilteredStoresUseCase {
    
    var repository: StoreRepository { get }
    
    init(repository: StoreRepository)
    
    func execute(
        filters: [CertificationType]
    ) -> [FilteredStores]
    
}
