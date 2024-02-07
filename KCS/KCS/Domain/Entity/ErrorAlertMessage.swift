//
//  ErrorAlertMessage.swift
//  KCS
//
//  Created by 조성민 on 1/30/24.
//

import Foundation

enum ErrorAlertMessage: LocalizedError {
    
    case server
    case internet
    case client
     
    var errorDescription: String? {
        switch self {
        case .server:
            return "서버와의 통신이 원활하지 않습니다"
        case .internet:
            return "인터넷 연결을 확인해주세요"
        case .client:
            return "알 수 없는 에러가 발생했습니다"
        }
    }
    
}
