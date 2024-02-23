//
//  SearchDependency.swift
//  KCS
//
//  Created by 김영현 on 2/20/24.
//

import Foundation

struct SearchDependency {
    
    let fetchRecentSearchHistoryUseCase: FetchRecentSearchHistoryUseCase
    let saveRecentSearchHistoryUseCase: SaveRecentSearchHistoryUseCase
    let deleteRecentSearchHistoryUseCase: DeleteRecentSearchHistoryUseCase
    let deleteAllHistoryUseCase: DeleteAllHistoryUseCase
    let getAutoCompletionUseCase: GetAutoCompletionUseCase
    
}
