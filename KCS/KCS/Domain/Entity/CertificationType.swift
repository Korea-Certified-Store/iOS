//
//  CertificationType.swift
//  KCS
//
//  Created by 조성민 on 1/9/24.
//

import Foundation

enum CertificationType: String, Hashable {
    
    case goodPrice = "착한가격업소"
    case exemplary = "모범음식점"
    case safe = "안심식당"
    
    var tag: Int {
        switch self {
        case .goodPrice:
            return 0
        case .exemplary:
            return 1
        case .safe:
            return 2
        }
    }
    
}

extension CertificationType: Comparable {
    
    static func < (lhs: CertificationType, rhs: CertificationType) -> Bool {
        return lhs.tag < rhs.tag
    }
    
}
