//
//  GetStoresUseCaseImpl.swift
//  KCS
//
//  Created by 조성민 on 1/18/24.
//

import Foundation

struct GetStoresUseCaseImpl: GetStoresUseCase {
    
    let repository: GetStoresRepository
    
    func execute(fetchCount: Int) -> [Store] {
        return repository.getStores(count: fetchCount)
    }

}
