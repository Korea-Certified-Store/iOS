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
    ) -> OpenClosedType {
        if openingHours.isEmpty {
            return OpenClosedType.none
        } else {
            let openHours = openingHours.filter({ $0.open.day.index == Date().weekDay })
            if openHours.isEmpty {
                return OpenClosedType.dayOff
            } else {
                return isOpen(openHours: openHours)
            }
        }
    }
    
}

private extension GetOpenClosedUseCaseImpl {
    
    func isOpen(openHours: [RegularOpeningHours]) -> OpenClosedType {
        let now = Date().toSecond()
        var openTimes: [Int] = []
        var closeTimes: [Int] = []
        openHours.forEach { businessHour in
            do {
                openTimes.append(try toSecond(businessHour: businessHour.open, openClose: .open))
                closeTimes.append(try toSecond(businessHour: businessHour.close, openClose: .close))
            } catch OpeningHourError.wrongHour {
                print(OpeningHourError.wrongHour.description)
            } catch OpeningHourError.wrongMinute {
                print(OpeningHourError.wrongMinute.description)
            } catch {
                print(error)
            }
        }
        
        for idx in openTimes.indices {
            if openTimes[idx] <= now && now <= closeTimes[idx] {
                return OpenClosedType.open
            }
        }
        
        return OpenClosedType.closed
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

enum OpenClose {
    
    case open
    case close
    
}
