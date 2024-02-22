//
//  FetchRecentSearchHistoryUseCaseImpl.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import RxSwift

struct FetchRecentSearchHistoryUseCaseImpl: FetchRecentSearchHistoryUseCase {
    
    let repository: FetchRecentSearchHistoryRepository
    
    func execute() -> Observable<[String]> {
        return repository.fetchRecentSearchHistory()
    }
    
}
