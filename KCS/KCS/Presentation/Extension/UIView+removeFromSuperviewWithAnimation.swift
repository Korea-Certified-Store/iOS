//
//  UIView+removeFromSuperviewWithAnimation.swift
//  KCS
//
//  Created by 조성민 on 2/19/24.
//

import UIKit

extension UIView {
    
    func removeFromSuperviewWithAnimation() {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: .curveEaseIn,
            animations: { [weak self] in
                self?.alpha = 1.0
            },
            completion: { [weak self] _ in
                UIView.animate(
                    withDuration: 0.6,
                    delay: 2.0,
                    options: .curveEaseOut,
                    animations: { [ weak self] in
                        self?.alpha = 0.0
                    }, completion: { [weak self] _ in
                        self?.removeFromSuperview()
                    }
                )
            }
        )
    }
    
}
