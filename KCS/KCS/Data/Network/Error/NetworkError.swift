//
//  NetworkError.swift
//  KCS
//
//  Created by 조성민 on 1/12/24.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    
    case wrongURL
    
    var errorDescription: String {
        switch self {
        case .wrongURL:
            return "URL이 잘못되었습니다."
        }
    }
    
}
