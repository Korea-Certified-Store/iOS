//
//  Marker.swift
//  KCS
//
//  Created by 조성민 on 1/9/24.
//

import UIKit
import NMapsMap
import RxSwift

final class Marker: NMFMarker {
    
    var isSelected: Bool = false {
        didSet {
            setUI(type: certificationType)
        }
    }
    
    private let certificationType: CertificationType

    init(certificationType: CertificationType, position: NMGLatLng? = nil) {
        self.certificationType = certificationType
        super.init()
        if let position = position {
            self.position = position
        }
        setUI(type: certificationType)
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

}
