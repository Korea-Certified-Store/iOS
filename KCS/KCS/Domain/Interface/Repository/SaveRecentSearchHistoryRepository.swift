//
//  SaveRecentSearchHistoryRepository.swift
//  KCS
//
//  Created by 김영현 on 2/22/24.
//

import Foundation

protocol SaveRecentSearchHistoryRepository {
    
    var userDefaults: UserDefaults { get }
    var recentSearchKeywordsKey: String { get }
    
    func saveRecentSearchHistory(recentSearchKeyword: String)
    
}
