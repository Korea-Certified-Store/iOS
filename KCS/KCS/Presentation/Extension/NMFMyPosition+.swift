//
//  NMFMyPosition+.swift
//  KCS
//
//  Created by 김영현 on 1/27/24.
//

import Foundation
import NMapsMap

extension NMFMyPositionMode {
    
    func getImageName() -> String? {
        switch self {
        case .direction:
            return "LocationButtonNormal"
        case .compass, .normal:
            return "LocationButtonCompass"
        default:
            return nil
        }
    }
    
}
