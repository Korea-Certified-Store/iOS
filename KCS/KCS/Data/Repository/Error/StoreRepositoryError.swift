//
//  StoreRepositoryError.swift
//  KCS
//
//  Created by 김영현 on 1/17/24.
//

import Foundation

enum StoreRepositoryError: Error, LocalizedError {
    
    case wrongStoreId
    case wrongStoreIndex
    
    var errorDescription: String {
        switch self {
        case .wrongStoreId:
            return "가게 Id가 올바르지 않습니다."
        case .wrongStoreIndex:
            return "가게 Index가 올바르지않습니다."
        }
    }
}
