//
//  SpySpyDeleteRecentSearchHistoryRepository.swift
//  KCSUnitTest
//
//  Created by 조성민 on 3/3/24.
//

import Foundation
@testable import KCS

final class SpyDeleteRecentSearchHistoryRepository: DeleteRecentSearchHistoryRepository {
    
    let userDefaults: UserDefaults
    let recentSearchKeywordsKey: String = "recentSearchKeywords"
    var executeCount: Int = 0
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func deleteRecentSearchHistory(index: Int) {
        self.executeCount += 1
    }
    
}
