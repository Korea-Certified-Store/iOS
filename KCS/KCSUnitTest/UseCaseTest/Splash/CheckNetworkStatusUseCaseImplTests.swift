//
//  CheckNetworkStatusUseCaseImplTests.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/25/24.
//

import XCTest
@testable import KCS
import RxSwift
import RxTest

final class CheckNetworkStatusUseCaseImplTests: XCTestCase {
    
    private var checkNetworkStatusUseCase: CheckNetworkStatusUseCase!
    
    func test_네트워크가_안정된_경우_execute는_True를_반환한다() {
        checkNetworkStatusUseCase = CheckNetworkStatusUseCaseImpl(
            repository: MockSuccessNetworkRepository()
        )
        XCTAssertTrue(checkNetworkStatusUseCase.execute())
    }
    
    func test_네트워크가_불안정한_경우_execute는_False를_반환한다() {
        checkNetworkStatusUseCase = CheckNetworkStatusUseCaseImpl(
            repository: MockFailureNetworkRepository()
        )
        XCTAssertFalse(checkNetworkStatusUseCase.execute())
    }

}
