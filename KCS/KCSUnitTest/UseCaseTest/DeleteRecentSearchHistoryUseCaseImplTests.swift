//
//  DeleteRecentSearchHistoryUseCaseImplTests.swift
//  KCSUnitTest
//
//  Created by 조성민 on 3/3/24.
//

import XCTest
@testable import KCS

struct DeleteRecentSearchHistoryUseCaseImplTestsConstant {
    
    let testIndex: Int = 1
    let dummyUserDefaults = UserDefaults()
    let resultExecuteCount = 1
    
}

final class DeleteRecentSearchHistoryUseCaseImplTests: XCTestCase {

    private var deleteRecentSearchHistoryUseCase: DeleteRecentSearchHistoryUseCaseImpl!
    private var spyDeleteRecentSearchHistoryRepository: SpyDeleteRecentSearchHistoryRepository!
    private var constant: DeleteRecentSearchHistoryUseCaseImplTestsConstant!
    
    override func setUp() {
        constant = DeleteRecentSearchHistoryUseCaseImplTestsConstant()
        spyDeleteRecentSearchHistoryRepository = SpyDeleteRecentSearchHistoryRepository(userDefaults: constant.dummyUserDefaults)
        deleteRecentSearchHistoryUseCase = DeleteRecentSearchHistoryUseCaseImpl(repository: spyDeleteRecentSearchHistoryRepository)
    }

    func test_Repository의_함수_호출을_성공하는_경우() {
        // Given initial statie
        
        // When
        deleteRecentSearchHistoryUseCase.execute(index: constant.testIndex)
        
        // Then
        XCTAssertEqual(spyDeleteRecentSearchHistoryRepository.executeCount, constant.resultExecuteCount)
    }

}
