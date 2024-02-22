//
//  DeleteRecentSearchHistoryUseCaseImpl.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import Foundation

struct DeleteRecentSearchHistoryUseCaseImpl: DeleteRecentSearchHistoryUseCase {
    
    let repository: DeleteRecentSearchHistoryRepository
    
    func execute(index: Int) {
        return repository.deleteRecentSearchHistory(index: index)
    }
    
}
