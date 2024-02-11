//
//  SearchDTO.swift
//  KCS
//
//  Created by 조성민 on 2/9/24.
//

import Foundation

struct SearchDTO: Encodable {
    
    let currLong: Double
    let currLat: Double
    let searchKeyword: String
    
}
