//
//  SearchKeywordsRepository.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import RxSwift

protocol SearchKeywordsRepository {
    
    func fetchRecentSearchKeywords() -> Observable<[RecentSearchKeyword]>
    func saveRecentSearchKeywords(recentSearchKeyword: RecentSearchKeyword)
    
}
