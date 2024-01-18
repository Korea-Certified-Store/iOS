//
//  Date+.swift
//  KCS
//
//  Created by 김영현 on 1/18/24.
//

import Foundation

extension Date {
    
    var weekDay: Int {
        let calendar = Calendar.current
        return calendar.component(.weekday, from: self)
    }
    
    var hour: Int {
        let calendar = Calendar.current
        return calendar.component(.hour, from: self)
    }
    
    var minute: Int {
        let calendar = Calendar.current
        return calendar.component(.minute, from: self)
    }
    
    func toSecond() -> Int {
        return (self.hour * 3600) + (self.minute * 60)
    }
    
}
