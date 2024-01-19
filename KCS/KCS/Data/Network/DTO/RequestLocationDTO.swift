//
//  RequestLocationDTO.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import Foundation

struct RequestLocationDTO: Encodable {
    
    let nwLong: Double
    let nwLat: Double
    let swLong: Double
    let swLat: Double
    let seLong: Double
    let seLat: Double
    let neLong: Double
    let neLat: Double
    
}
