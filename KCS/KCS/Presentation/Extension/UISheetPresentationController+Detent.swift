//
//  UISheetPresentationController+Detent.swift
//  KCS
//
//  Created by 조성민 on 2/3/24.
//

import UIKit

extension UISheetPresentationController.Detent.Identifier {
    static let smallSummaryDetentIdentifier = UISheetPresentationController.Detent.Identifier("SmallSummaryDetent")
    static let largeSummaryDetentIdentifier = UISheetPresentationController.Detent.Identifier("LargeSummaryDetent")
    static let detailDetentIdentifier = UISheetPresentationController.Detent.Identifier("DetailDetent")
}
            
extension UISheetPresentationController.Detent {
    
    static let smallSummaryViewDetent = custom(identifier: .smallSummaryDetentIdentifier) { _ in
        return 230 - 21
    }
    static let largeSummaryViewDetent = custom(identifier: .largeSummaryDetentIdentifier) { _ in
        return 253 - 21
    }
    static let detailViewDetent = custom(identifier: .detailDetentIdentifier) { _ in
        return 616 - 21
    }
    
}
