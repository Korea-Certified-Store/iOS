//
//  CertificationType.swift
//  KCS
//
//  Created by 조성민 on 1/9/24.
//

import Foundation

enum CertificationType: String {
    
    case goodPrice = "착한가격업소"
    case exemplary = "모범음식점"
    case safe = "안심식당"
    
    var description: String {
        switch self {
        case .goodPrice:
            return "착한 가격 업소"
        case .exemplary:
            return "모범 음식점"
        case .safe:
            return "안심 식당"
        }
    }
}
