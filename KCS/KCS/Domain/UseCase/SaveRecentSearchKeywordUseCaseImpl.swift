//
//  SaveRecentSearchKeywordUseCaseImpl.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import RxSwift

struct SaveRecentSearchKeywordUseCaseImpl: SaveRecentSearchKeywordUseCase {
    
    let repository: SearchKeywordsRepository
    
    func execute(recentSearchKeyword: String) {
        return repository.saveRecentSearchKeywords(recentSearchKeyword: recentSearchKeyword)
    }
    
}
