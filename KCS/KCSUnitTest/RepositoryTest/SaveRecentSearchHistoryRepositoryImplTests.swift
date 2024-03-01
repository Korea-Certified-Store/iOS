//
//  SaveRecentSearchHistoryRepositoryImplTests.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/29/24.
//

import XCTest
@testable import KCS

struct SaveRecentSearchHistoryRepositoryImplTestsConstant {
    
    let key = "recentSearchKeywords"
    let recentHistory: [String] = ["검색어1", "검색어2", "검색어3"]
    let recentHistoryOver30: [String] = [
        "검색어1", "검색어2", "검색어3", "검색어4", "검색어5",
        "검색어6", "검색어7", "검색어8", "검색어9", "검색어10",
        "검색어11", "검색어12", "검색어13", "검색어14", "검색어15",
        "검색어16", "검색어17", "검색어18", "검색어19", "검색어20",
        "검색어21", "검색어22", "검색어23", "검색어24", "검색어25",
        "검색어26", "검색어27", "검색어28", "검색어29", "검색어30"
    ]
    let resultOneRecentHistory: [String] = ["검색어1"]
    let resultNewRecentHistory: [String] = ["검색어4", "검색어1", "검색어2", "검색어3"]
    let resultReinsertRecentHistory: [String] = ["검색어3", "검색어1", "검색어2"]
    let resultOver30RecentHistory: [String] = [
        "검색어31", "검색어1", "검색어2", "검색어3", "검색어4",
        "검색어5", "검색어6", "검색어7", "검색어8", "검색어9",
        "검색어10", "검색어11", "검색어12", "검색어13", "검색어14",
        "검색어15", "검색어16", "검색어17", "검색어18", "검색어19",
        "검색어20", "검색어21", "검색어22", "검색어23", "검색어24",
        "검색어25", "검색어26", "검색어27", "검색어28", "검색어29"
    ]
    
}

final class SaveRecentSearchHistoryRepositoryImplTests: XCTestCase {
    
    private var saveRecentSearchHistoryRepository: SaveRecentSearchHistoryRepositoryImpl!
    private var userDefaults: FakeUserDefaults!
    private var constant: SaveRecentSearchHistoryRepositoryImplTestsConstant!

    override func setUp() {
        userDefaults = FakeUserDefaults()
        constant = SaveRecentSearchHistoryRepositoryImplTestsConstant()
        saveRecentSearchHistoryRepository = SaveRecentSearchHistoryRepositoryImpl(
            userDefaults: userDefaults
        )
    }
    
    func test_최근검색어가_처음_추가되는_경우() {
        // Given
        let recentSearchKeyword = "검색어1"
        
        // When
        saveRecentSearchHistoryRepository.saveRecentSearchHistory(
            recentSearchKeyword: recentSearchKeyword
        )
        
        // Then
        if let recentHistory = userDefaults.array(forKey: constant.key) as? [String] {
            XCTAssertEqual(recentHistory, constant.resultOneRecentHistory)
        } else {
            XCTFail("최근 검색어 추가 실패")
        }
    }

    func test_새로운_최근검색어가_추가되는_경우() {
        // Given
        let recentSearchKeyword = "검색어4"
        userDefaults.set(constant.recentHistory, forKey: constant.key)
        
        // When
        saveRecentSearchHistoryRepository.saveRecentSearchHistory(
            recentSearchKeyword: recentSearchKeyword
        )
        
        // Then
        if let recentHistory = userDefaults.array(forKey: constant.key) as? [String] {
            XCTAssertEqual(recentHistory, constant.resultNewRecentHistory)
        } else {
            XCTFail("새로운 최근 검색어 추가 실패")
        }
    }
    
    func test_최근검색어_배열에_존재하던_검색어가_다시_저장되는_경우() {
        // Given
        let recentSearchKeyword = "검색어3"
        userDefaults.set(constant.recentHistory, forKey: constant.key)
        
        // When
        saveRecentSearchHistoryRepository.saveRecentSearchHistory(
            recentSearchKeyword: recentSearchKeyword
        )
        
        // Then
        if let recentHistory = userDefaults.array(forKey: constant.key) as? [String] {
            XCTAssertEqual(recentHistory, constant.resultReinsertRecentHistory)
        } else {
            XCTFail("존재하던 최근 검색어 추가 실패")
        }
    }
    
    func test_최근검색어_배열이_30개가_넘어가는_경우() {
        // Given
        let recentSearchKeyword = "검색어31"
        userDefaults.set(constant.recentHistoryOver30, forKey: constant.key)
        
        // When
        saveRecentSearchHistoryRepository.saveRecentSearchHistory(
            recentSearchKeyword: recentSearchKeyword
        )
        
        // Then
        if let recentHistory = userDefaults.array(forKey: constant.key) as? [String] {
            XCTAssertEqual(recentHistory, constant.resultOver30RecentHistory)
        } else {
            XCTFail("30개 초과시 새로운 최근 검색어 추가 실패")
        }
    }

}
