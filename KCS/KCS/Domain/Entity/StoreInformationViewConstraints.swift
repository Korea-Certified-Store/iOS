//
//  StoreInformationViewConstraints.swift
//  KCS
//
//  Created by 김영현 on 1/27/24.
//

import Foundation

struct StoreInformationViewConstraints {
    
    let heightConstraint: CGFloat
    let bottomConstraint: CGFloat
    let animated: Bool
    
    init(heightConstraint: CGFloat, bottomConstraint: CGFloat, animated: Bool = false) {
        self.heightConstraint = heightConstraint
        self.bottomConstraint = bottomConstraint
        self.animated = animated
    }
    
}
