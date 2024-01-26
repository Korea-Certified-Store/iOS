//
//  OpeningHourInformation.swift
//  KCS
//
//  Created by 김영현 on 1/20/24.
//

import Foundation

struct OpeningHourInformation {
    
    let openClosedContent: OpenClosedContent
    let detailOpeningHour: [DetailOpeningHour]
    
}

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
