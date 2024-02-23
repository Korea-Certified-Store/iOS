//
//  DeleteRecentSearchHistoryRepositoryImpl.swift
//  KCS
//
//  Created by 김영현 on 2/22/24.
//

import Foundation

struct DeleteRecentSearchHistoryRepositoryImpl: DeleteRecentSearchHistoryRepository {
    
    let userDefaults: UserDefaults
    let recentSearchKeywordsKey = "recentSearchKeywords"
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func deleteRecentSearchHistory(index: Int) {
        var keywords = userDefaults.array(forKey: recentSearchKeywordsKey) as? [String] ?? []
        keywords.remove(at: index)
        userDefaults.set(keywords, forKey: recentSearchKeywordsKey)
    }
    
}
