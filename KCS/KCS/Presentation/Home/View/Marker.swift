//
//  Marker.swift
//  KCS
//
//  Created by 조성민 on 1/9/24.
//

import UIKit
import NMapsMap

final class Marker: NMFMarker {
    
    init(type: CetificationType) {
        super.init()
        setUI(type: type)
    }
    
    init(type: CetificationType, position: NMGLatLng) {
        super.init()
        self.position = position
        setUI(type: type)
    }
    
}

private extension Marker {
    
    func setUI(type: CetificationType) {
        var icon = NMFOverlayImage()
        switch type {
        case .goodPrice:
            icon = NMFOverlayImage(image: UIImage.markerGoodPriceNormal)
        case .exemplary:
            icon = NMFOverlayImage(image: UIImage.markerExemplaryNormal)
        case .safe:
            icon = NMFOverlayImage(image: UIImage.markerSafeNormal)
        }
        self.iconImage = icon
    }
    
}
