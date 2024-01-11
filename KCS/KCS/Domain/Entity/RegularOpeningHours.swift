//
//  RegularOpeningHours.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import Foundation

struct RegularOpeningHours {
    
    let open: BusinessHour
    let close: BusinessHour
    
}

struct BusinessHour {
    
    let day: Day
    let hour: Int
    let minute: Int
    
}
