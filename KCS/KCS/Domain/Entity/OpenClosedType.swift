//
//  OpenClosedType.swift
//  KCS
//
//  Created by 김영현 on 1/18/24.
//

import Foundation

enum OpenClosedType: String {
    
    case open = "영업 중"
    case closed = "영업 종료"
    case breakTime = "브레이크 타임"
    case dayOff = "휴무일"
    case alwaysOpen = "24시간 영업"
    case none = ""
    
    var description: String {
        switch self {
        case .open, .alwaysOpen:
            return OpenClosedType.open.rawValue
        case .closed:
            return OpenClosedType.closed.rawValue
        case .breakTime:
            return OpenClosedType.breakTime.rawValue
        case .dayOff:
            return OpenClosedType.dayOff.rawValue
        case .none:
            return OpenClosedType.none.rawValue
        }
    }
    
}

enum OpenClose {
    
    case open
    case close
    
}
