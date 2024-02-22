//
//  FetchRecentSearchHistoryRepository.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import RxSwift

protocol FetchRecentSearchHistoryRepository {
    
    var userDefaults: UserDefaults { get }
    var recentSearchKeywordsKey: String { get }
    
    func fetchRecentSearchHistory() -> Observable<[String]>
    
}
