//
//  SetStoreIDUseCaseImpl.swift
//  KCS
//
//  Created by 조성민 on 2/18/24.
//

import Foundation

struct SetStoreIDUseCaseImpl: SetStoreIDUseCase {
    
    var repository: SetStoreIDRepository
    
    func execute(id: Int) {
        repository.fetchStoreID(id: id)
    }
    
}
