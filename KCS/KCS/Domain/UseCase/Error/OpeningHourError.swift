//
//  OpeningHourError.swift
//  KCS
//
//  Created by 김영현 on 1/18/24.
//

import Foundation

enum OpeningHourError: Error, LocalizedError, Equatable {
    
    case wrongHour
    case wrongMinute
    
    var description: String {
        switch self {
        case .wrongHour:
            return "잘못된 hour입니다."
        case .wrongMinute:
            return "잘못된 minute입니다."
        }
    }
    
}
