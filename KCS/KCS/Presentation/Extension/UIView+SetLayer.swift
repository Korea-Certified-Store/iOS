//
//  UIView+SetLayer.swift
//  KCS
//
//  Created by 김영현 on 1/11/24.
//

import UIKit

extension UIView {
    
    func setLayerShadow(shadowOffset: CGSize) {
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = 0.25
        layer.shadowColor = UIColor.primary1.cgColor
    }
    
    func setLayerCorner(
        cornerRadius: CGFloat,
        maskedCorners: CACornerMask = [
            .layerMaxXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMinXMinYCorner
        ]
    ) {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = maskedCorners
    }
    
}
