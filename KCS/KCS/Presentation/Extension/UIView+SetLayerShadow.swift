//
//  UIView+SetLayerShadow.swift
//  KCS
//
//  Created by 김영현 on 1/11/24.
//

import UIKit

extension UIView {
    
    func setLayerShadow() {
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.25
        layer.shadowColor = UIColor.primary.cgColor
    }
    
}
