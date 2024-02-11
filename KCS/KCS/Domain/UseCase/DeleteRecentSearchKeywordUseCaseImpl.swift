//
//  DeleteRecentSearchKeywordUseCaseImpl.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import Foundation

struct DeleteRecentSearchKeywordUseCaseImpl: DeleteRecentSearchKeywordUseCase {
    
    var repository: SearchKeywordsRepository
    
    func execute(index: Int) {
        return repository.deleteRecentSearchKeywords(index: index)
    }
    
}
