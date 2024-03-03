//
//  DeleteAllHistoryUseCaseImplTests.swift
//  KCSUnitTest
//
//  Created by 조성민 on 3/3/24.
//

import XCTest
@testable import KCS

struct DeleteAllHistoryUseCaseImplTestsTestsConstant {
    
    let testKeyword = "TestKeyword"
    let dummyUserDefaults = UserDefaults()
    let resultExecuteCount = 1
    
}

final class DeleteAllHistoryUseCaseImplTestsTests: XCTestCase {

    private var deleteAllHistoryUseCase: DeleteAllHistoryUseCaseImpl!
    private var spyDeleteAllHistoryRepository: SpyDeleteAllHistoryRepository!
    private var constant: DeleteAllHistoryUseCaseImplTestsTestsConstant!
    
    override func setUp() {
        constant = DeleteAllHistoryUseCaseImplTestsTestsConstant()
        spyDeleteAllHistoryRepository = SpyDeleteAllHistoryRepository(userDefaults: constant.dummyUserDefaults)
        deleteAllHistoryUseCase = DeleteAllHistoryUseCaseImpl(repository: spyDeleteAllHistoryRepository)
    }

    func test_Repository의_함수를_성공하는_경우() {
        // Given initial statie
        
        // When
        deleteAllHistoryUseCase.execute()
        
        // Then
        XCTAssertEqual(spyDeleteAllHistoryRepository.executeCount, constant.resultExecuteCount)
    }

}
