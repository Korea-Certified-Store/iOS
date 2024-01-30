//
//  ErrorAlertMessage.swift
//  KCS
//
//  Created by 조성민 on 1/30/24.
//

import Foundation

enum ErrorAlertMessage: LocalizedError {
    
    case server
    case data
    
    var errorDescription: String {
        switch self {
        case .server:
            return "서버와의 통신이 원활하지 않습니다"
        case .data:
            return "데이터를 불러올 수 없습니다"
        }
    }
    
}
