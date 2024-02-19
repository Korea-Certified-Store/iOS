//
//  NewStoreRequestDTO.swift
//  KCS
//
//  Created by 김영현 on 2/19/24.
//

import Foundation

struct NewStoreRequestDTO: Encodable {
    
    let storeName: String
    let formattedAddress: String
    let certifications: [String]
    
}
