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
    
    private lazy var unselectedGlobalZIndex: Int = self.globalZIndex
    private let selectImage: UIImage
    private let deselectImage: UIImage

    init(position: NMGLatLng? = nil, selectImage: UIImage, deselectImage: UIImage) {
        self.selectImage = selectImage
        self.deselectImage = deselectImage
        super.init()
        if let position = position {
            self.position = position
        }
//        setUI(type: certificationType)
    }
    
}

private extension Marker {
    
//    func setUI(type: CertificationType) {
//        var icon = NMFOverlayImage()
//        if isSelected {
//            switch type {
//            case .goodPrice:
//                icon = NMFOverlayImage(image: UIImage.markerGoodPriceSelected)
//            case .exemplary:
//                icon = NMFOverlayImage(image: UIImage.markerExemplarySelected)
//            case .safe:
//                icon = NMFOverlayImage(image: UIImage.markerSafeSelected)
//            }
//            self.globalZIndex = 250000
//        } else {
//            switch type {
//            case .goodPrice:
//                icon = NMFOverlayImage(image: UIImage.markerGoodPriceNormal)
//            case .exemplary:
//                icon = NMFOverlayImage(image: UIImage.markerExemplaryNormal)
//            case .safe:
//                icon = NMFOverlayImage(image: UIImage.markerSafeNormal)
//            }
//            self.globalZIndex = unselectedGlobalZIndex
//        }
//        self.iconImage = icon
//    }

}
