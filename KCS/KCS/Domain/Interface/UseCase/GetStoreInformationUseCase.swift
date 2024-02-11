//
//  GetStoreInformationUseCase.swift
//  KCS
//
//  Created by 김영현 on 1/17/24.
//

import Foundation

protocol GetStoreInformationUseCase {
    
    var repository: StoreRepository { get }
    
    init(repository: StoreRepository)
    
    func execute(tag: UInt) throws -> Store
    
}
