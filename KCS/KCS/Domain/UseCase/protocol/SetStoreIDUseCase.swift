//
//  SetStoreIDUseCase.swift
//  KCS
//
//  Created by 조성민 on 2/18/24.
//

import Foundation

protocol SetStoreIDUseCase {
    
    var repository: SetStoreIDRepository { get }
    
    init(repository: SetStoreIDRepository)
    
    func execute(id: Int)
    
}
