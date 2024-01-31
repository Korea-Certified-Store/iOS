//
//  StoreTableViewCellContents.swift
//  KCS
//
//  Created by 조성민 on 2/1/24.
//

import Foundation

struct StoreTableViewCellContents: Hashable {
    
    let storeTitle: String
    let category: String?
    let certificationTypes: [CertificationType]
    let thumbnailImageData: Data?
    
}
