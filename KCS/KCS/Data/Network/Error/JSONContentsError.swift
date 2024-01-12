//
//  JSONContentsError.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import Foundation

enum JSONContentsError: Error, LocalizedError {
    
    case wrongDay
    case wrongCertificationType
    case wrongCategory
    case dictionaryConvert
    
    var errorDescription: String {
        switch self {
        case .wrongDay:
            return "Day의 형식이 잘못되어 있습니다."
        case .wrongCertificationType:
            return "CetificationType의 형식이 잘못되어 있습니다."
        case .wrongCategory:
            return "Category의 형식이 잘못되어 있습니다."
        case .dictionaryConvert:
            return "JSONSerialization에 실패했습니다."
        }
    }
    
}
