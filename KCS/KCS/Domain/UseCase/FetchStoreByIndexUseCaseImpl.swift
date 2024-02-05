//
//  FetchStoreByIndexUseCaseImpl.swift
//  KCS
//
//  Created by 조성민 on 2/5/24.
//

import Foundation

struct FetchStoreByIndexUseCaseImpl: FetchStoreByIndexUseCase {
    
    let repository: StoreRepository
    
    func execute(index: Int) throws -> Store {
        return try repository.getStoreByIndex(index: index)
    }
    
}
