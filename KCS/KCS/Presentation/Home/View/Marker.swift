//
//  Marker.swift
//  KCS
//
//  Created by 조성민 on 1/9/24.
//

import UIKit
import NMapsMap

enum StoreType {
    
    case goodPrice
    case exemplary
    case safe
    
}

final class Marker: NMFMarker {
    
    init(type: StoreType) {
        super.init()
        setUI(type: type)
    }
    
    init(type: StoreType, position: NMGLatLng) {
        super.init()
        self.position = position
        setUI(type: type)
    }
    
}

private extension Marker {
    
    func setUI(type: StoreType) {
        var icon = NMFOverlayImage()
        switch type {
        case .goodPrice:
            icon = NMF_MARKER_IMAGE_RED
        case .exemplary:
            icon = NMF_MARKER_IMAGE_BLUE
        case .safe:
            icon = NMF_MARKER_IMAGE_GREEN
        }
        self.iconImage = icon
    }
    
}
