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
    case none = ""
    
}

enum OpenClose {
    
    case open
    case close
    
}
