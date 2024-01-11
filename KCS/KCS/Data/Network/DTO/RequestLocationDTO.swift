//
//  RequestLocationDTO.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import Foundation

struct RequestLocationDTO: Encodable {
    
    let northWestLocation: LocationDTO
    let southEastLocation: LocationDTO
    
}
