//
//  GetStoresUseCase.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import Foundation

protocol GetStoresUseCase {
    
    var repository: StoreRepository { get }
    
    init(repository: StoreRepository)
    
    func execute(
        type: CertificationType
    ) -> [Store]
    
}
