//
//  GetOpenClosedUseCaseImpl.swift
//  KCS
//
//  Created by 김영현 on 1/18/24.
//

import Foundation

struct GetOpenClosedUseCaseImpl: GetOpenClosedUseCase {
    
    func execute(
        openingHours: [RegularOpeningHours],
        today: Date
    ) throws -> OpenClosedContent {
        return try getOpenClosedContent(openingHour: openingHours, today: today)
    }
    
}

private extension GetOpenClosedUseCaseImpl {
    
    func getOpenClosedContent(openingHour: [RegularOpeningHours], today: Date) throws -> OpenClosedContent {
        let nowOpenClosedType = try getOpenClosedType(openingHour: openingHour, today: today)
        let openingHourString: String = try {
            switch nowOpenClosedType {
            case .none:
                return OpenClosedType.none.rawValue
            case .dayOff:
                return OpenClosedType.dayOff.rawValue
            case .alwaysOpen:
                return OpenClosedType.alwaysOpen.rawValue
            case .breakTime, .closed:
                return try getOpenClosedString(openingHour: openingHour, openClosedType: .open, today: today)
            case .open:
                return try getOpenClosedString(openingHour: openingHour, openClosedType: .close, today: today)
            }
        }()
        
        return OpenClosedContent(openClosedType: nowOpenClosedType, nextOpeningHour: openingHourString)
    }
}

private extension GetOpenClosedUseCaseImpl {
    
    func getOpenClosedType(openingHour: [RegularOpeningHours], today: Date) throws -> OpenClosedType {
        if openingHour.isEmpty {
            return OpenClosedType.none
        }
        if !openingHour.filter({ $0.open == $0.close }).isEmpty {
            return OpenClosedType.alwaysOpen
        }
        let openCloseTime = try getOpenClosedTimeArray(openingHours: openingHour, today: today)
        if openCloseTime.isEmpty {
            return OpenClosedType.dayOff
        }
        let now = today.toSecond()
        for idx in 0..<(openCloseTime.count - 1) {
            let firstTime = openCloseTime[idx]
            let secondTime = openCloseTime[idx + 1]
            if firstTime <= now && now < secondTime {
                if idx % 2 == 0 {
                    if secondTime - firstTime <= 10800 {
                        return OpenClosedType.breakTime
                    } else {
                        return OpenClosedType.closed
                    }
                } else {
                    return OpenClosedType.open
                }
            }
        }
        
        return OpenClosedType.dayOff
    }
    
    func getOpenClosedString(openingHour: [RegularOpeningHours], openClosedType: OpenClose, today: Date) throws -> String {
        let openCloseTime = try getOpenClosedTimeArray(openingHours: openingHour, today: today)
        var nextTime = openCloseTime.filter({ $0 > today.toSecond() })
        switch openClosedType {
        case .open:
            let nextTime = nextTime.removeFirst()
            if nextTime != 86400 * 2 {
                let hour = (nextTime % 86400) / 3600
                let minute = (nextTime % 3600) / 60
                return String(format: "%02d:%02d에 영업 시작", hour, minute)
            } else {
                return ""
            }
        case .close:
            let firstNextTime = nextTime.removeFirst()
            let secondNextTime = nextTime.removeFirst()
            let hour = (firstNextTime % 86400) / 3600
            let minute = (firstNextTime % 3600) / 60
            if secondNextTime - firstNextTime <= 10800 {
                return String(format: "%02d:%02d에 브레이크타임 시작", hour, minute)
            } else {
                return String(format: "%02d:%02d에 영업 종료", hour, minute)
            }
        }
    }
    
    func getOpenClosedTimeArray(openingHours: [RegularOpeningHours], today: Date) throws -> [Int] {
        var openCloseTime: [Int] = []
        let todayOpenHours = filteredOpeningHours(openingHours: openingHours, day: 0, today: today)
        if todayOpenHours.isEmpty {
            return []
        }
        let yesterdayOpenHours = filteredOpeningHours(openingHours: openingHours, day: -1, today: today)
        let tomorrowOpenHours = filteredOpeningHours(openingHours: openingHours, day: 1, today: today)
        
        openCloseTime.append(contentsOf: try appendYesterdayClosedHour(openingHours: yesterdayOpenHours))
        openCloseTime.append(contentsOf: try appendTodayOpenClosedHour(openingHours: todayOpenHours))
        openCloseTime.append(contentsOf: try appendTomorrowOpenHour(openingHours: tomorrowOpenHours))
        
        return openCloseTime
    }
    
    func filteredOpeningHours(openingHours: [RegularOpeningHours], day: Int, today: Date) -> [RegularOpeningHours] {
        openingHours.filter { hour in
            let weekDay = (today.weekDay + day) % 7 == 0 ? 7 : (today.weekDay + day) % 7
            return hour.open.day.index == weekDay
        }
    }
    
    func appendYesterdayClosedHour(openingHours: [RegularOpeningHours]) throws -> [Int] {
        guard let businessHour = openingHours.last?.close else { return [.zero] }
        return [try catchHourError(businessHour: businessHour, openClose: .close) - 86400]
    }
    
    func appendTodayOpenClosedHour(openingHours: [RegularOpeningHours]) throws -> [Int] {
        var openCloseTime: [Int] = []
        try openingHours.forEach { businessHour in
            openCloseTime.append(try catchHourError(businessHour: businessHour.open, openClose: .open))
            openCloseTime.append(try catchHourError(businessHour: businessHour.close, openClose: .close))
        }
        
        return openCloseTime
    }
    
    func appendTomorrowOpenHour(openingHours: [RegularOpeningHours]) throws -> [Int] {
        guard let businessHour = openingHours.first?.open else { return [86400 * 2] }
        return [try catchHourError(businessHour: businessHour, openClose: .open) + 86400]
    }
    
    func catchHourError(businessHour: BusinessHour, openClose: OpenClose) throws -> Int {
        return try toSecond(businessHour: businessHour, openClose: openClose)
    }
    
    func toSecond(businessHour: BusinessHour, openClose: OpenClose) throws -> Int {
        var hour = businessHour.hour
        let minute = businessHour.minute
        if 0 <= hour && hour < 24 {
            if 0 <= minute && minute < 60 {
                if openClose == OpenClose.close && hour == 0 {
                    hour = 24
                }
                return (hour * 3600) + (minute * 60)
            } else {
                throw OpeningHourError.wrongMinute
            }
        } else {
            throw OpeningHourError.wrongHour
        }
    }
    
}
