//
//  Marker.swift
//  KCS
//
//  Created by 조성민 on 1/9/24.
//

import UIKit
import NMapsMap

final class Marker: NMFMarker {
    
    var isSelected: Bool = false

    init(type: CertificationType, position: NMGLatLng? = nil) {
        super.init()
        if let position = position {
            self.position = position
        }
        setUI(type: type)
        setHandler(type: type)
    }
    
}

private extension Marker {
    
    func setUI(type: CertificationType) {
        var icon = NMFOverlayImage()
        if isSelected {
            switch type {
            case .goodPrice:
                icon = NMFOverlayImage(image: UIImage.markerGoodPriceSelected)
            case .exemplary:
                icon = NMFOverlayImage(image: UIImage.markerExemplarySelected)
            case .safe:
                icon = NMFOverlayImage(image: UIImage.markerSafeSelected)
            }
        } else {
            switch type {
            case .goodPrice:
                icon = NMFOverlayImage(image: UIImage.markerGoodPriceNormal)
            case .exemplary:
                icon = NMFOverlayImage(image: UIImage.markerExemplaryNormal)
            case .safe:
                icon = NMFOverlayImage(image: UIImage.markerSafeNormal)
            }
        }
        self.iconImage = icon
    }
    
    func setHandler(type: CertificationType) {
        touchHandler = { [weak self] (_: NMFOverlay) -> Bool in
            guard let self = self else { return false }
            isSelected = !isSelected
            setUI(type: type)
            
            return true
        }
    }
    
}
