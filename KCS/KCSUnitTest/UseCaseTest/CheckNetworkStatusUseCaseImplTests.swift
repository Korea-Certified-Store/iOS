//
//  CheckNetworkStatusUseCaseImplTests.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/25/24.
//

import XCTest
@testable import KCS

final class CheckNetworkStatusUseCaseImplTests: XCTestCase {
    
    private var checkNetworkStatusUseCase: CheckNetworkStatusUseCase!
    
    func test_네트워크가_안정한_경우() {
        // Given initial state
        
        // When
        checkNetworkStatusUseCase = CheckNetworkStatusUseCaseImpl(
            repository: StubSuccessNetworkRepository()
        )
        
        // Then
        XCTAssertTrue(checkNetworkStatusUseCase.execute())
    }
    
    func test_네트워크가_불안정한_경우() {
        // Given initial state
        
        // When
        checkNetworkStatusUseCase = CheckNetworkStatusUseCaseImpl(
            repository: StubFailureNetworkRepository()
        )
        
        // Then
        XCTAssertFalse(checkNetworkStatusUseCase.execute())
    }

}
