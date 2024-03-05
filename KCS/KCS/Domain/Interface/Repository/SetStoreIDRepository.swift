//
//  SetStoreIDRepository.swift
//  KCS
//
//  Created by 김영현 on 3/3/24.
//

import Foundation

protocol SetStoreIDRepository {
    
    var storage: StoreIDStorage { get }
    
    func setStoreID(id: Int)
    
}
