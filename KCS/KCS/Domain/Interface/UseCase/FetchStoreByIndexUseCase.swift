//
//  FetchStoreByIndexUseCase.swift
//  KCS
//
//  Created by 조성민 on 2/5/24.
//

import Foundation

protocol FetchStoreByIndexUseCase {
    
    var repository: StoreRepository { get }
    
    init(repository: StoreRepository)
    
    func execute(index: Int) throws -> Store
    
}
