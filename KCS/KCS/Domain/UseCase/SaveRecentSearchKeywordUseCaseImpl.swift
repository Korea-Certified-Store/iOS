//
//  SaveRecentSearchKeywordUseCaseImpl.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import RxSwift

struct SaveRecentSearchKeywordUseCaseImpl: SaveRecentSearchKeywordUseCase {
    
    var repository: SearchKeywordsRepository
    
    func execute(recentSearchKeyword: RecentSearchKeyword) {
        return repository.saveRecentSearchKeywords(recentSearchKeyword: recentSearchKeyword)
    }
    
}
