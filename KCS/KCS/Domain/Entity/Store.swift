//
//  Store.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import Foundation

struct Store {
    
    let id: Int
    let title: String
    let certificationTypes: [CertificationType]
    let category: String?
    let address: String
    let phoneNumber: String?
    let location: Location
    let openingHour: [RegularOpeningHours]
    
}
