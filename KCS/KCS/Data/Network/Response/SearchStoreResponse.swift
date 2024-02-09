//
//  SearchStoreResponse.swift
//  KCS
//
//  Created by 조성민 on 2/9/24.
//

import Foundation

struct SearchStoreResponse: APIResponse {
    
    typealias ResponseType = [StoreDTO]
    
    let code: Int
    let message: String
    let data: ResponseType
    
}
