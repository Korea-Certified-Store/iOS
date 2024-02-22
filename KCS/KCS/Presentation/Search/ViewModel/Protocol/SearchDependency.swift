//
//  SearchDependency.swift
//  KCS
//
//  Created by 김영현 on 2/20/24.
//

import Foundation

struct SearchDependency {
    
    let fetchRecentSearchKeywordUseCase: FetchRecentSearchHistoryUseCase
    let saveRecentSearchKeywordUseCase: SaveRecentSearchHistoryUseCase
    let deleteRecentSearchKeywordUseCase: DeleteRecentSearchHistoryUseCase
    let deleteAllHistoryUseCase: DeleteAllHistoryUseCase
    let getAutoCompletionUseCase: GetAutoCompletionUseCase
    
}
