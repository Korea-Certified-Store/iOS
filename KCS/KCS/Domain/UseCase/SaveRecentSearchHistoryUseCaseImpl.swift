//
//  SaveRecentSearchHistoryUseCaseImpl.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import RxSwift

struct SaveRecentSearchHistoryUseCaseImpl: SaveRecentSearchHistoryUseCase {
    
    let repository: SaveRecentSearchHistoryRepository
    
    func execute(recentSearchKeyword: String) {
        return repository.saveRecentSearchHistory(recentSearchKeyword: recentSearchKeyword)
    }
    
}
