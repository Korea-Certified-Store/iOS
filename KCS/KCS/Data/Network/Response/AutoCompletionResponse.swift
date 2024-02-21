//
//  AutoCompletionResponse.swift
//  KCS
//
//  Created by 김영현 on 2/17/24.
//

import Foundation

struct AutoCompletionResponse: APIResponse {
    
    typealias ResponseType = [String]
    
    let code: Int
    let message: String
    let data: ResponseType
    
}
