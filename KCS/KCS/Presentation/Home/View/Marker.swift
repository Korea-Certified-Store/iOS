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
    private let selectImage: NMFOverlayImage
    private let deselectImage: NMFOverlayImage

    init(position: NMGLatLng? = nil, selectImage: UIImage, deselectImage: UIImage) {
        self.selectImage = NMFOverlayImage(image: selectImage)
        self.deselectImage = NMFOverlayImage(image: deselectImage)
        super.init()
        if let position = position {
            self.position = position
        }
        self.iconImage = self.deselectImage
    }
    
}

extension Marker {
    
    func select() {
        self.iconImage = selectImage
        self.globalZIndex = 250000
    }
    
    func deselect() {
        self.iconImage = deselectImage
        self.globalZIndex = unselectedGlobalZIndex
    }

}
