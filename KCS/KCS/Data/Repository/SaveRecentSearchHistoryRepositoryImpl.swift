//
//  SaveRecentSearchHistoryRepositoryImpl.swift
//  KCS
//
//  Created by 김영현 on 2/22/24.
//

import Foundation

struct SaveRecentSearchHistoryRepositoryImpl: SaveRecentSearchHistoryRepository {
    
    let userDefaults: UserDefaults
    let recentSearchKeywordsKey = "recentSearchKeywords"
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func saveRecentSearchHistory(recentSearchKeyword: String) {
        guard var keywords = userDefaults.array(forKey: recentSearchKeywordsKey) as? [String] else { return }
        if let index = keywords.firstIndex(of: recentSearchKeyword) {
            keywords.remove(at: index)
        }
        keywords.insert(recentSearchKeyword, at: 0)
        if keywords.count > 30 {
            keywords.removeLast()
        }
        userDefaults.set(keywords, forKey: recentSearchKeywordsKey)
    }
    
}
