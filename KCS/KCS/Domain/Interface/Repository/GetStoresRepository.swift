//
//  GetStoresRepository.swift
//  KCS
//
//  Created by 조성민 on 2/22/24.
//

import Foundation

protocol GetStoresRepository {
    
    var storeStorage: StoreStorage { get }
    
    func getStores() -> [Store]
    
}
