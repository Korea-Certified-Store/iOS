//
//  UIStackView+clear.swift
//  KCS
//
//  Created by 조성민 on 2/1/24.
//

import UIKit

extension UIStackView {
    
    func clear() {
        let subviews = arrangedSubviews
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
        }
        subviews.forEach { $0.removeFromSuperview() }
    }
    
}
