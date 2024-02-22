//
//  DeleteAllHistoryRepositoryImpl.swift
//  KCS
//
//  Created by 김영현 on 2/22/24.
//

import Foundation

struct DeleteAllHistoryRepositoryImpl: DeleteAllHistoryRepository {
    
    let userDefaults: UserDefaults
    let recentSearchKeywordsKey = "recentSearchKeywords"
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func deleteAllHistory() {
        userDefaults.set([], forKey: recentSearchKeywordsKey)
    }
    
}
