//
//  FetchRecentSearchHistoryRepositoryImpl.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import RxSwift
import RxRelay

struct FetchRecentSearchHistoryRepositoryImpl: FetchRecentSearchHistoryRepository {
    
    let userDefaults: UserDefaults
    let recentSearchKeywordsKey = "recentSearchKeywords"
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func fetchRecentSearchHistory() -> Observable<[String]> {
        return Observable.create { observer -> Disposable in
            let keywords = userDefaults.array(forKey: recentSearchKeywordsKey) as? [String] ?? []
            observer.onNext(keywords)
            return Disposables.create()
        }
    }
    
}
