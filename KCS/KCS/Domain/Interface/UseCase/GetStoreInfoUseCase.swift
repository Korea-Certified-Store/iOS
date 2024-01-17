//
//  GetStoreInfoUseCase.swift
//  KCS
//
//  Created by 김영현 on 1/17/24.
//

import Foundation

protocol GetStoreInfoUseCase {
    
    var repository: StoreRepository { get }
    
    init(repository: StoreRepository)
    
    func execute(tag: UInt) -> Store?
    
}
