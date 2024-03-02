//
//  GetOpenClosedUseCaseImplTests.swift
//  KCSUnitTest
//
//  Created by 김영현 on 3/2/24.
//

import XCTest
@testable import KCS

struct GetOpenClosedUseCaseImplTestsConstant {
    
    let emptyOpeningHour: [RegularOpeningHours] = []
    let alwaysOpenOpeningHour = [
        RegularOpeningHours(
            open: BusinessHour(day: Day.sunday, hour: 0, minute: 0),
            close: BusinessHour(day: Day.sunday, hour: 0, minute: 0)
        ),
        RegularOpeningHours(
            open: BusinessHour(day: Day.monday, hour: 0, minute: 0),
            close: BusinessHour(day: Day.monday, hour: 0, minute: 0)
        ),
        RegularOpeningHours(
            open: BusinessHour(day: Day.tuesday, hour: 0, minute: 0),
            close: BusinessHour(day: Day.tuesday, hour: 0, minute: 0)
        )
    ]
    let dayOffOpeningHour = [
        RegularOpeningHours(
            open: BusinessHour(day: Day.sunday, hour: 10, minute: 0),
            close: BusinessHour(day: Day.sunday, hour: 20, minute: 0)
        ),
        RegularOpeningHours(
            open: BusinessHour(day: Day.tuesday, hour: 10, minute: 0),
            close: BusinessHour(day: Day.tuesday, hour: 20, minute: 0)
        )
    ]
    let openWithNoBreakTimeOpeningHour = [
        RegularOpeningHours(
            open: BusinessHour(day: Day.sunday, hour: 10, minute: 0),
            close: BusinessHour(day: Day.sunday, hour: 20, minute: 0)
        ),
        RegularOpeningHours(
            open: BusinessHour(day: Day.monday, hour: 10, minute: 0),
            close: BusinessHour(day: Day.monday, hour: 20, minute: 0)
        ),
        RegularOpeningHours(
            open: BusinessHour(day: Day.tuesday, hour: 10, minute: 0),
            close: BusinessHour(day: Day.tuesday, hour: 20, minute: 0)
        )
    ]
    let openWithBreakTimeOpeningHour = [
        RegularOpeningHours(
            open: BusinessHour(day: Day.sunday, hour: 10, minute: 0),
            close: BusinessHour(day: Day.sunday, hour: 20, minute: 0)
        ),
        RegularOpeningHours(
            open: BusinessHour(day: Day.monday, hour: 10, minute: 0),
            close: BusinessHour(day: Day.monday, hour: 13, minute: 0)
        ),
        RegularOpeningHours(
            open: BusinessHour(day: Day.monday, hour: 14, minute: 0),
            close: BusinessHour(day: Day.monday, hour: 20, minute: 0)
        ),
        RegularOpeningHours(
            open: BusinessHour(day: Day.tuesday, hour: 10, minute: 0),
            close: BusinessHour(day: Day.tuesday, hour: 20, minute: 0)
        )
    ]
    let closedWithDayOffOpeningHour = [
        RegularOpeningHours(
            open: BusinessHour(day: Day.sunday, hour: 10, minute: 0),
            close: BusinessHour(day: Day.sunday, hour: 20, minute: 0)
        ),
        RegularOpeningHours(
            open: BusinessHour(day: Day.monday, hour: 10, minute: 0),
            close: BusinessHour(day: Day.monday, hour: 20, minute: 0)
        )
    ]
    let closedAfter24OpeningHour = [
        RegularOpeningHours(
            open: BusinessHour(day: Day.sunday, hour: 17, minute: 0),
            close: BusinessHour(day: Day.sunday, hour: 0, minute: 0)
        ),
        RegularOpeningHours(
            open: BusinessHour(day: Day.monday, hour: 0, minute: 0),
            close: BusinessHour(day: Day.monday, hour: 3, minute: 0)
        ),
        RegularOpeningHours(
            open: BusinessHour(day: Day.monday, hour: 17, minute: 0),
            close: BusinessHour(day: Day.monday, hour: 0, minute: 0)
        ),
        RegularOpeningHours(
            open: BusinessHour(day: Day.tuesday, hour: 0, minute: 0),
            close: BusinessHour(day: Day.tuesday, hour: 3, minute: 0)
        )
    ]
    let wrongHourOpeningHour = [
        RegularOpeningHours(
            open: BusinessHour(day: Day.sunday, hour: 10, minute: 0),
            close: BusinessHour(day: Day.sunday, hour: 24, minute: 0)
        ),
        RegularOpeningHours(
            open: BusinessHour(day: Day.monday, hour: 10, minute: 0),
            close: BusinessHour(day: Day.monday, hour: 20, minute: 0)
        ),
        RegularOpeningHours(
            open: BusinessHour(day: Day.tuesday, hour: 10, minute: 0),
            close: BusinessHour(day: Day.tuesday, hour: 20, minute: 0)
        )
    ]
    let wrongMinuteOpeningHour = [
        RegularOpeningHours(
            open: BusinessHour(day: Day.sunday, hour: 10, minute: 0),
            close: BusinessHour(day: Day.sunday, hour: 20, minute: 0)
        ),
        RegularOpeningHours(
            open: BusinessHour(day: Day.monday, hour: 10, minute: 70),
            close: BusinessHour(day: Day.monday, hour: 20, minute: 0)
        ),
        RegularOpeningHours(
            open: BusinessHour(day: Day.tuesday, hour: 10, minute: 0),
            close: BusinessHour(day: Day.tuesday, hour: 20, minute: 0)
        )
    ]
    let openDate = Date(timeIntervalSinceReferenceDate: 10800) // 2001년 1월 1일 12시 0분 0초 (월)
    let closeDate = Date(timeIntervalSinceReferenceDate: 43200) // 2001년 1월 1일 21시 0분 0초 (월)
    let breakTimeDate = Date(timeIntervalSinceReferenceDate: 16200) // 2001년 1월 1일 13시 30분 0초 (월)
    
    let noneOpenClosedContent = OpenClosedContent(openClosedType: .none, nextOpeningHour: OpenClosedType.none.rawValue)
    let alwaysOpenOpenClosedContent = OpenClosedContent(openClosedType: .alwaysOpen, nextOpeningHour: OpenClosedType.alwaysOpen.rawValue)
    let dayOffOpenClosedContent = OpenClosedContent(openClosedType: .dayOff, nextOpeningHour: OpenClosedType.dayOff.rawValue)
    let openWithNoBreakTimeOpenClosedContent = OpenClosedContent(openClosedType: .open, nextOpeningHour: String(format: "%02d:%02d에 영업 종료", 20, 0))
    let openWithBreakTimeOpenClosedContent = OpenClosedContent(openClosedType: .open, nextOpeningHour: String(format: "%02d:%02d에 브레이크타임 시작", 13, 0))
    let closedWithNoDayOffOpenClosedContent = OpenClosedContent(openClosedType: .closed, nextOpeningHour: String(format: "%02d:%02d에 영업 시작", 10, 0))
    let closedWithDayOffOpenClosedContent = OpenClosedContent(openClosedType: .closed, nextOpeningHour: "")
    let closedAfter24OpenClosedContent = OpenClosedContent(openClosedType: .closed, nextOpeningHour: String(format: "%02d:%02d에 영업 시작", 17, 0))
    let breakTimeOpenClosedContent = OpenClosedContent(openClosedType: .breakTime, nextOpeningHour: String(format: "%02d:%02d에 영업 시작", 14, 0))
}

final class GetOpenClosedUseCaseImplTests: XCTestCase {

    private var constant: GetOpenClosedUseCaseImplTestsConstant!
    private var getOpenClosedUseCase: GetOpenClosedUseCaseImpl!
    
    override func setUp() {
        constant = GetOpenClosedUseCaseImplTestsConstant()
        getOpenClosedUseCase = GetOpenClosedUseCaseImpl()
    }
    
    func test_가게운영시간_정보가_없는_경우() {
        // Given initial state
        
        // When
        do {
            let result = try getOpenClosedUseCase.execute(openingHours: constant.emptyOpeningHour, today: constant.openDate)
            
            // Then
            XCTAssertEqual(result, constant.noneOpenClosedContent)
        } catch {
            XCTFail("가게 운영 시간 확인 실패")
        }
    }
    
    func test_가게가_24시간_영업중인_경우() {
        // Given initial state
        
        // When
        do {
            let result = try getOpenClosedUseCase.execute(openingHours: constant.alwaysOpenOpeningHour, today: constant.openDate)
            
            // Then
            XCTAssertEqual(result, constant.alwaysOpenOpenClosedContent)
        } catch {
            XCTFail("가게 운영 시간 확인 실패")
        }
    }
    
    func test_가게가_휴무일인_경우() {
        // Given initial state
        
        // When
        do {
            let result = try getOpenClosedUseCase.execute(openingHours: constant.dayOffOpeningHour, today: constant.openDate)
            
            // Then
            XCTAssertEqual(result, constant.dayOffOpenClosedContent)
        } catch {
            XCTFail("가게 운영 시간 확인 실패")
        }
    }
    
    func test_가게가_영업중이며_브레이크타임이_없는_경우() {
        // Given initial state
        
        // When
        do {
            let result = try getOpenClosedUseCase.execute(openingHours: constant.openWithNoBreakTimeOpeningHour, today: constant.openDate)
            
            // Then
            XCTAssertEqual(result, constant.openWithNoBreakTimeOpenClosedContent)
        } catch {
            XCTFail("가게 운영 시간 확인 실패")
        }
    }
    
    func test_가게가_영업중이며_브레이크타임이_있는_경우() {
        // Given initial state
        
        // When
        do {
            let result = try getOpenClosedUseCase.execute(openingHours: constant.openWithBreakTimeOpeningHour, today: constant.openDate)
            
            // Then
            XCTAssertEqual(result, constant.openWithBreakTimeOpenClosedContent)
        } catch {
            XCTFail("가게 운영 시간 확인 실패")
        }
    }
    
    func test_가게가_영업종료이며_다음날이_휴무일이_아닐_경우() {
        // Given initial state
        
        // When
        do {
            let result = try getOpenClosedUseCase.execute(openingHours: constant.openWithNoBreakTimeOpeningHour, today: constant.closeDate)
            
            // Then
            XCTAssertEqual(result, constant.closedWithNoDayOffOpenClosedContent)
        } catch {
            XCTFail("가게 운영 시간 확인 실패")
        }
    }
    
    func test_가게가_영업종료이며_다음날이_휴무일일_경우() {
        // Given initial state
        
        // When
        do {
            let result = try getOpenClosedUseCase.execute(openingHours: constant.closedWithDayOffOpeningHour, today: constant.closeDate)
            
            // Then
            XCTAssertEqual(result, constant.closedWithDayOffOpenClosedContent)
        } catch {
            XCTFail("가게 운영 시간 확인 실패")
        }
    }
    
    func test_가게가_브레이크타임인_경우() {
        // Given initial state
        
        // When
        do {
            let result = try getOpenClosedUseCase.execute(openingHours: constant.openWithBreakTimeOpeningHour, today: constant.breakTimeDate)
            
            // Then
            XCTAssertEqual(result, constant.breakTimeOpenClosedContent)
        } catch {
            XCTFail("가게 운영 시간 확인 실패")
        }
    }
    
    func test_오전12시_이후_영업종료를_하는_가게일_경우() {
        // Given initial state
        
        // When
        do {
            let result = try getOpenClosedUseCase.execute(openingHours: constant.closedAfter24OpeningHour, today: constant.openDate)
            
            // Then
            XCTAssertEqual(result, constant.closedAfter24OpenClosedContent)
        } catch {
            XCTFail("가게 운영 시간 확인 실패")
        }
    }
    
    func test_가게_영업_정보_중_시단위가_잘못된_경우() {
        // Given initial state
        
        // When
        do {
            let result = try getOpenClosedUseCase.execute(openingHours: constant.wrongHourOpeningHour, today: constant.openDate)
            
            // Then
            XCTFail("가게 운영 시간 확인 실패")
        } catch let error as OpeningHourError {
            XCTAssertEqual(error, OpeningHourError.wrongHour)
        } catch {
            XCTFail("가게 운영 시간 확인 실패")
        }
    }
    
    func test_가게_영업_정보_중_분단위_잘못된_경우() {
        // Given initial state
        
        // When
        do {
            let result = try getOpenClosedUseCase.execute(openingHours: constant.wrongMinuteOpeningHour, today: constant.openDate)
            
            // Then
            XCTFail("가게 운영 시간 확인 실패")
        } catch let error as OpeningHourError {
            XCTAssertEqual(error, OpeningHourError.wrongMinute)
        } catch {
            XCTFail("가게 운영 시간 확인 실패")
        }
    }

}
