//
//  RefreshStoreResponse.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import Foundation

struct RefreshStoreResponse: APIResponse {
    
    typealias ResponseType = [[StoreDTO]]
    
    let code: Int
    let message: String
    let data: ResponseType
    
}
