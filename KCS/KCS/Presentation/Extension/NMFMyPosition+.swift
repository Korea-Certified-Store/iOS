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
            return "LocationButtonCompass"
        case .compass, .normal:
            return "LocationButtonNormal"
        default:
            return nil
        }
    }
    
}
