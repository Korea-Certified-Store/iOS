//
//  SearchKeywordRepositoryImpl.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import RxSwift
import RxRelay

final class SearchKeywordRepositoryImpl: SearchKeywordsRepository {
    
    private var userDefaults: UserDefaults
    private let recentSearchKeywordsKey = "recentSearchKeywords"
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func fetchRecentSearchKeywords() -> Observable<[RecentSearchKeyword]> {
        return Observable.create { [weak self] observer -> Disposable in
            if let keywords = self?.fetchKeywords() {
                observer.onNext(keywords)
            }
            return Disposables.create()
        }
    }
    
    func saveRecentSearchKeywords(recentSearchKeyword: RecentSearchKeyword) {
        var keywords = fetchKeywords()
        if let index = keywords.firstIndex(of: recentSearchKeyword) {
            keywords.remove(at: index)
        }
        keywords.insert(recentSearchKeyword, at: 0)
        if keywords.count > 5 {
            keywords.removeLast()
        }
        persist(keywords: keywords)
    }
    
    func deleteRecentSearchKeywords(index: Int) {
        var keywords = fetchKeywords()
        keywords.remove(at: index)
        persist(keywords: keywords)
    }
    
}

private extension SearchKeywordRepositoryImpl {
    
    func fetchKeywords() -> [RecentSearchKeyword] {
        if let recentSearchKeywordData = userDefaults.object(forKey: recentSearchKeywordsKey) as? Data {
            if let recentSearchKeyword = try? JSONDecoder().decode(RecentSearchKeywordsListUDS.self, from: recentSearchKeywordData) {
                return recentSearchKeyword.searchKeywordsList.map { $0.toEntity() }
            }
        }
        return []
    }
    
    func persist(keywords: [RecentSearchKeyword]) {
        let encoder = JSONEncoder()
        let recentSearchKeywordsListUDS = keywords.map(RecentSearchKeywordsUDS.init)
        if let encoded = try? encoder.encode(RecentSearchKeywordsListUDS(searchKeywordsList: recentSearchKeywordsListUDS)) {
            userDefaults.set(encoded, forKey: recentSearchKeywordsKey)
        }
    }
    
}
