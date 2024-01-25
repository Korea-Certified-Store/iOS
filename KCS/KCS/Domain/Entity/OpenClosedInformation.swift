//
//  OpenClosedInformation.swift
//  KCS
//
//  Created by 김영현 on 1/20/24.
//

import Foundation

struct OpenClosedInformation {
    
    let openClosedContent: OpenClosedContent
    let detailOpeningHour: [Day: OpeningHour]
    
}

struct OpenClosedContent {
    
    let openClosedType: OpenClosedType
    let openingHour: String
    
}

struct OpeningHour {
    
    let openingHour: String?
    let breakTime: String?
    
}
