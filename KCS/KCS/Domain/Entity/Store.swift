//
//  Store.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import Foundation

struct Store {
    
    let title: String
    let type: [StoreType]
    let category: StoreCategory
    let address: String
    let phoneNumber: String
    let location: Location
    let openingHour: [BusinessHour]
    
}
