//
//  JSONContentsError.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import Foundation

enum JSONContentsError: Error, LocalizedError {
    
    case wrongDay
    case wrongStoreType
    case wrongCategory
    
    var errorDescription: String {
        switch self {
        case .wrongDay:
            return "Day의 형식이 잘못되어 있습니다."
        case .wrongStoreType:
            return "StoreType의 형식이 잘못되어 있습니다."
        case .wrongCategory:
            return "Category의 형식이 잘못되어 있습니다."
        }
    }
    
}
