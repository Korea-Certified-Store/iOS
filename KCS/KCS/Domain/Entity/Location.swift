//
//  Location.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import Foundation
import NMapsMap

struct Location {
    
    let longitude: Double
    let latitude: Double
    
    func toMapLocation() -> NMGLatLng {
        return NMGLatLng(lat: latitude, lng: longitude)
    }
    
}
