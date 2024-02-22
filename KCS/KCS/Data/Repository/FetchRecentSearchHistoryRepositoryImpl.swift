//
//  FetchRecentSearchHistoryRepositoryImpl.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import RxSwift
import RxRelay

final class FetchRecentSearchHistoryRepositoryImpl: FetchRecentSearchHistoryRepository {
    
    let userDefaults: UserDefaults
    let recentSearchKeywordsKey = "recentSearchKeywords"
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func fetchRecentSearchHistory() -> Observable<[String]> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            let keywords = userDefaults.array(forKey: recentSearchKeywordsKey) as? [String] ?? []
            observer.onNext(keywords)
            return Disposables.create()
        }
    }
    
}
