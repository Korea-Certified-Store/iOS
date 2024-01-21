//
//  UILabel+.swift
//  KCS
//
//  Created by 김영현 on 1/21/24.
//

import UIKit

extension UILabel {
    
    var numberOfVisibleLines: Int {
        layoutIfNeeded()
        let textSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let textHeight = lroundf(Float(sizeThatFits(textSize).height))
        let lineHeight = lroundf(Float(font.lineHeight))
        
        return textHeight/lineHeight
    }
    
}
