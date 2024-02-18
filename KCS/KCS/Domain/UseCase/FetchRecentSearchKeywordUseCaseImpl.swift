//
//  FetchRecentSearchKeywordUseCaseImpl.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import RxSwift

struct FetchRecentSearchKeywordUseCaseImpl: FetchRecentSearchKeywordUseCase {
    
    let repository: SearchKeywordsRepository
    
    func execute() -> Observable<[String]> {
        return repository.fetchRecentSearchKeywords()
    }
    
}
