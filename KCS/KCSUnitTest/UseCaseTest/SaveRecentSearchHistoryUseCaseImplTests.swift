//
//  SaveRecentSearchHistoryUseCaseImplTests.swift
//  KCSUnitTest
//
//  Created by 조성민 on 3/2/24.
//

import XCTest
@testable import KCS

struct SaveRecentSearchHistoryUseCaseImplTestsConstant {
    
    let testKeyword = "TestKeyword"
    let dummyUserDefaults = UserDefaults()
    let resultExecuteCount = 1
    
}

final class SaveRecentSearchHistoryUseCaseImplTests: XCTestCase {

    private var saveRecentSearchHistoryUseCase: SaveRecentSearchHistoryUseCaseImpl!
    private var spySaveRecentSearchHistoryRepository: SpySaveRecentSearchHistoryRepository!
    private var constant: SaveRecentSearchHistoryUseCaseImplTestsConstant!
    
    override func setUp() {
        constant = SaveRecentSearchHistoryUseCaseImplTestsConstant()
        spySaveRecentSearchHistoryRepository = SpySaveRecentSearchHistoryRepository(userDefaults: constant.dummyUserDefaults)
        saveRecentSearchHistoryUseCase = SaveRecentSearchHistoryUseCaseImpl(repository: spySaveRecentSearchHistoryRepository)
    }

    func test_Repository의_함수를_성공하는_경우() {
        // Given initial statie
        
        // When
        saveRecentSearchHistoryUseCase.execute(recentSearchKeyword: constant.testKeyword)
        
        // Then
        XCTAssertEqual(spySaveRecentSearchHistoryRepository.executeCount, constant.resultExecuteCount)
    }

}
