//
//  DeleteAllHistoryRepositoryImplTests.swift
//  KCSUnitTest
//
//  Created by 김영현 on 3/1/24.
//

import XCTest
@testable import KCS

struct DeleteAllHistoryRepositoryImplTestsConstant {
    
    let key = "recentSearchKeywords"
    let recentHistory: [String] = ["검색어1", "검색어2", "검색어3"]
    
}

final class DeleteAllHistoryRepositoryImplTests: XCTestCase {
    
    private var deleteAllHistoryRepository: DeleteAllHistoryRepository!
    private var userDefaults: MockUserDefaults!
    private var constant: DeleteAllHistoryRepositoryImplTestsConstant!

    override func setUp() {
        constant = DeleteAllHistoryRepositoryImplTestsConstant()
        userDefaults = MockUserDefaults()
        userDefaults.set(constant.recentHistory, forKey: constant.key)
        deleteAllHistoryRepository = DeleteAllHistoryRepositoryImpl(
            userDefaults: userDefaults
        )
    }
    
    func test_key에_해당하는_모든_최근검색어를_삭제하는_경우() {
        // Given initial state
        // When
        deleteAllHistoryRepository.deleteAllHistory()
        
        // Then
        if let result = userDefaults.array(forKey: constant.key) as? [String] {
            XCTAssertEqual(result, [])
        } else {
            XCTFail("최근 검색어 모두 삭제 실패")
        }
    }

}
