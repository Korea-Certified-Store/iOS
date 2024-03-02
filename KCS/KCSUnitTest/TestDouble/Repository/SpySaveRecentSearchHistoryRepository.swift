//
//  SpySaveRecentSearchHistoryRepository.swift
//  KCSUnitTest
//
//  Created by 조성민 on 3/2/24.
//

import Foundation
@testable import KCS

final class SpySaveRecentSearchHistoryRepository: SaveRecentSearchHistoryRepository {
    
    let userDefaults: UserDefaults
    let recentSearchKeywordsKey: String = "recentSearchKeywords"
    var executeCount: Int = 0
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func saveRecentSearchHistory(recentSearchKeyword: String) {
        self.executeCount += 1
    }
    
}
