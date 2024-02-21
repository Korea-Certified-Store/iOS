//
//  SearchKeywordRepositoryImpl.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import RxSwift
import RxRelay

final class SearchKeywordRepositoryImpl: SearchKeywordsRepository {
    
    private let userDefaults: UserDefaults
    private let recentSearchKeywordsKey = "recentSearchKeywords"
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func fetchRecentSearchKeywords() -> Observable<[String]> {
        return Observable.create { [weak self] observer -> Disposable in
            if let keywords = self?.fetchKeywords() {
                observer.onNext(keywords)
            }
            return Disposables.create()
        }
    }
    
    func saveRecentSearchKeywords(recentSearchKeyword: String) {
        var keywords = fetchKeywords()
        if let index = keywords.firstIndex(of: recentSearchKeyword) {
            keywords.remove(at: index)
        }
        keywords.insert(recentSearchKeyword, at: 0)
        if keywords.count > 30 {
            keywords.removeLast()
        }
        persist(keywords: keywords)
    }
    
    func deleteRecentSearchKeywords(index: Int) {
        var keywords = fetchKeywords()
        keywords.remove(at: index)
        persist(keywords: keywords)
    }
    
    func deleteAllHistory() {
        persist(keywords: [])
    }
    
}

private extension SearchKeywordRepositoryImpl {
    
    func fetchKeywords() -> [String] {
        if let recentSearchKeywordArray = userDefaults.array(forKey: recentSearchKeywordsKey) as? [String] {
            return recentSearchKeywordArray
        }
        return []
    }
    
    func persist(keywords: [String]) {
        userDefaults.set(keywords, forKey: recentSearchKeywordsKey)
    }
    
}
