//
//  FetchStoresUseCase.swift
//  KCS
//
//  Created by 조성민 on 1/18/24.
//

import Foundation

protocol FetchStoresUseCase {
    
    var repository: StoreRepository { get }
    
    init(repository: StoreRepository)
    
    func execute() -> [Store]

}
