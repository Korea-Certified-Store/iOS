//
//  SetStoreIDUseCase.swift
//  KCS
//
//  Created by 조성민 on 2/18/24.
//

import Foundation

protocol SetStoreIDUseCase {
    
    var storage: StoreIDStorage { get }
    
    func execute(id: Int)
    
}
