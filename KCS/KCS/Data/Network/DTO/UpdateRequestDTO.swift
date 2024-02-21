//
//  UpdateRequestDTO.swift
//  KCS
//
//  Created by 조성민 on 2/18/24.
//

import Foundation

struct UpdateRequestDTO: Encodable {
    
    let dtype: String
    let storeId: Int
    let contents: String
    
}
