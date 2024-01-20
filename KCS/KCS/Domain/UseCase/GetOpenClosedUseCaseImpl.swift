//
//  GetOpenClosedUseCaseImpl.swift
//  KCS
//
//  Created by 김영현 on 1/18/24.
//

import Foundation

struct GetOpenClosedUseCaseImpl: GetOpenClosedUseCase {
    
    func execute(
        openingHours: [RegularOpeningHours]
    ) -> OpenClosedContent {
        return getOpenClosedContent(openingHour: openingHours)
    }
    
}

private extension GetOpenClosedUseCaseImpl {
    
    func getOpenClosedContent(openingHour: [RegularOpeningHours]) -> OpenClosedContent {
        dump(openingHour)
        let nowOpenClosedType = getOpenClosedType(openingHour: openingHour)
        lazy var openingHourString: String = {
            switch nowOpenClosedType {
            case .none, .dayOff:
                return OpenClosedType.none.rawValue
            case .breakTime, .closed:
                return getOpenClosedString(openingHour: openingHour, openClosedType: .open)
            case .open:
                return getOpenClosedString(openingHour: openingHour, openClosedType: .close)
            }
        }()
        
        return OpenClosedContent(openClosedType: nowOpenClosedType, openingHour: openingHourString)
        
    }
}

private extension GetOpenClosedUseCaseImpl {
    
    func getOpenClosedType(openingHour: [RegularOpeningHours]) -> OpenClosedType {
        
        if openingHour.isEmpty {
            return OpenClosedType.none
        }
        
        let openCloseTime = getOpenClosedTimeArray(openingHours: openingHour)
        
        let now = Date().toSecond()
        
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
    
    func getOpenClosedString(openingHour: [RegularOpeningHours], openClosedType: OpenClose) -> String {
        
        let openCloseTime = getOpenClosedTimeArray(openingHours: openingHour)
        let nextTime = openCloseTime.filter({ $0 > Date().toSecond() })
        
        switch openClosedType {
        case .open:
            if let nextTime = nextTime.first {
                if nextTime != 86400 * 2 {
                    let hour = (nextTime % 86400) / 3600
                    let minute = (nextTime % 3600) / 60
                    return String(format: "%02d:%02d에 영업 시작", hour, minute)
                }
            }
        case .close:
            if nextTime.count > 1 {
                let firstNextTime = nextTime[0]
                let secondNextTime = nextTime[1]
                let hour = (firstNextTime % 86400) / 3600
                let minute = (firstNextTime % 3600) / 60
                if secondNextTime - firstNextTime <= 10800 {
                    return String(format: "%02d:%02d에 브레이크타임 시작", hour, minute)
                } else {
                    return String(format: "%02d:%02d에 영업 종료", hour, minute)
                }
            }
        }

        return ""
    }
    
    func getOpenClosedTimeArray(openingHours: [RegularOpeningHours]) -> [Int] {
        
        var openCloseTime: [Int] = []
        
        let todayOpenHours = openingHours.filter { $0.open.day.index == Date().weekDay }
        let yesterdayOpenHours = openingHours.filter { hour in
            let yesterdayWeekDay = (Date().weekDay - 1) % 7 == 0 ? 7 : (Date().weekDay + 1) % 7
            return hour.open.day.index == yesterdayWeekDay
        }
        let tomorrowOpenHours = openingHours.filter { hour in
            let tomorrowWeekDay = (Date().weekDay + 1) % 7 == 0 ? 7 : (Date().weekDay + 1) % 7
            return hour.open.day.index == tomorrowWeekDay
        }
        
        if todayOpenHours.isEmpty {
            return []
        }
        
        if let businessHour = yesterdayOpenHours.last?.close {
            if let time = catchHourError(businessHour: businessHour, openClose: .close) {
                openCloseTime.append(time - 86400)
            } else {
                openCloseTime.append(0)
            }
        } else {
            openCloseTime.append(0)
        }
        
        todayOpenHours.forEach { businessHour in
            if let openHour = catchHourError(businessHour: businessHour.open, openClose: .open),
               let closeHour = catchHourError(businessHour: businessHour.close, openClose: .close) {
                openCloseTime.append(openHour)
                openCloseTime.append(closeHour)
            }
        }
        
        if let businessHour = tomorrowOpenHours.first?.open {
            if let time = catchHourError(businessHour: businessHour, openClose: .open) {
                openCloseTime.append(time + 86400)
            } else {
                openCloseTime.append(86400 * 2)
            }
        } else {
            openCloseTime.append(86400 * 2)
        }
        
        return openCloseTime
    }
    
    func catchHourError(businessHour: BusinessHour, openClose: OpenClose) -> Int? {
        do {
            return try toSecond(businessHour: businessHour, openClose: openClose)
        } catch OpeningHourError.wrongHour {
            print(OpeningHourError.wrongHour.description)
        } catch OpeningHourError.wrongMinute {
            print(OpeningHourError.wrongMinute.description)
        } catch {
            print(error)
        }
        
        return nil
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
