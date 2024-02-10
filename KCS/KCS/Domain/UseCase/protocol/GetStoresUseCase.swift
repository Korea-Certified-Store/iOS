//
//  GetStoresUseCase.swift
//  KCS
//
//  Created by 조성민 on 1/18/24.
//

import Foundation

protocol GetStoresUseCase {
    
    var repository: GetStoresRepository { get }
    
    init(repository: GetStoresRepository)
    
    func execute(fetchCount: Int) -> [Store]

}
