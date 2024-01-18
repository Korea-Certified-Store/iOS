//
//  RegularOpeningHours.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import Foundation

struct RegularOpeningHours: Hashable {
    
    let open: BusinessHour
    let close: BusinessHour
    
}

struct BusinessHour: Hashable {
    
    let day: Day
    let hour: Int
    let minute: Int
    
}
