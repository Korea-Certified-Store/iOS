//
//  DeleteRecentSearchHistoryRepositoryImplTests.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/29/24.
//

import XCTest
@testable import KCS

struct DeleteRecentSearchHistoryRepositoryImplTestsConstant {
    
    let key = "recentSearchKeywords"
    let recentHistory: [String] = ["검색어1", "검색어2", "검색어3"]
    let resultRecentHistory: [String] = ["검색어1", "검색어3"]
    
}

final class DeleteRecentSearchHistoryRepositoryImplTests: XCTestCase {
    
    private var deleteRecentSearchHistoryRepository: DeleteRecentSearchHistoryRepository!
    private var userDefaults: MockUserDefaults!
    private var constant: DeleteRecentSearchHistoryRepositoryImplTestsConstant!

    override func setUp() {
        userDefaults = MockUserDefaults()
        deleteRecentSearchHistoryRepository = DeleteRecentSearchHistoryRepositoryImpl(
            userDefaults: userDefaults
        )
        constant = DeleteRecentSearchHistoryRepositoryImplTestsConstant()
    }
    
    func test_1번째_인덱스_최근검색어를_삭제하는_경우() {
        // Given
        userDefaults.set(constant.recentHistory, forKey: constant.key)
        
        // When
        deleteRecentSearchHistoryRepository.deleteRecentSearchHistory(index: 1)
        
        // Then
        if let result = userDefaults.array(forKey: constant.key) as? [String] {
            XCTAssertEqual(result, constant.resultRecentHistory)
        } else {
            XCTFail("검색어 삭제 실패")
        }
    }
    
}
