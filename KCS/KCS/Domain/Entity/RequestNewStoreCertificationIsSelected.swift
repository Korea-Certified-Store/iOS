//
//  RequestNewStoreCertificationIsSelected.swift
//  KCS
//
//  Created by 김영현 on 2/19/24.
//

import Foundation

struct RequestNewStoreCertificationIsSelected {
    
    var goodPrice: Bool = false
    var exemplary: Bool = false
    var safe: Bool = false
    
    func toArray() -> [CertificationType] {
        var certifications: [CertificationType] = []
        if goodPrice { certifications.append(.goodPrice) }
        if exemplary { certifications.append(.exemplary) }
        if safe { certifications.append(.safe) }
        
        return certifications
    }
    
}
