//
//  Marker.swift
//  KCS
//
//  Created by 조성민 on 1/9/24.
//

import UIKit
import NMapsMap

final class Marker: NMFMarker {
    
    init(type: CertificationType, position: NMGLatLng? = nil) {
        super.init()
        if let position = position {
            self.position = position
        }
        setUI(type: type)
    }
    
}

private extension Marker {
    
    func setUI(type: CertificationType) {
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
