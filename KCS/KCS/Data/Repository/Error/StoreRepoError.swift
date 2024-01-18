//
//  StoreRepoError.swift
//  KCS
//
//  Created by 김영현 on 1/17/24.
//

import Foundation

enum StoreRepoError: Error, LocalizedError {
    
    case wrongStoreId
    
    var errorDescription: String {
        switch self {
        case .wrongStoreId:
            return "가게 Id가 올바르지 않습니다."
        }
    }
}
