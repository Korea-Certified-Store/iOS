//
//  GetStoreInformationUseCase.swift
//  KCS
//
//  Created by 김영현 on 1/17/24.
//

import Foundation

protocol GetStoreInformationUseCase {
    
    var repository: GetStoresRepository { get }
    
    init(repository: GetStoresRepository)
    
    func execute(tag: UInt) throws -> Store
    
}
