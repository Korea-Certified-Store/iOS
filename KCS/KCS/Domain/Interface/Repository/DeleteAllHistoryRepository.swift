//
//  DeleteAllHistoryRepository.swift
//  KCS
//
//  Created by 김영현 on 2/22/24.
//

import Foundation

protocol DeleteAllHistoryRepository {
    
    var userDefaults: UserDefaults { get }
    var recentSearchKeywordsKey: String { get }
    
    func deleteAllHistory()
    
}
