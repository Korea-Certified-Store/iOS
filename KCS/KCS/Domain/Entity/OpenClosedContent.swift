//
//  OpenClosedContent.swift
//  KCS
//
//  Created by 김영현 on 1/20/24.
//

import Foundation

struct OpenClosedContent {
    
    let openClosedType: OpenClosedType
    let nextOpeningHour: String
    
}

struct DetailOpeningHour {
    
    let weekDay: Day
    let openingHour: OpeningHour
    
}

struct OpeningHour {
    
    let openingHour: String?
    let breakTime: String?
    
}
