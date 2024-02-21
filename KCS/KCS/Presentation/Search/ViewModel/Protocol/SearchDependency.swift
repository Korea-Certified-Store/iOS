//
//  SearchDependency.swift
//  KCS
//
//  Created by 김영현 on 2/20/24.
//

import Foundation

struct SearchDependency {
    
    let fetchRecentSearchKeywordUseCase: FetchRecentSearchKeywordUseCase
    let saveRecentSearchKeywordUseCase: SaveRecentSearchKeywordUseCase
    let deleteRecentSearchKeywordUseCase: DeleteRecentSearchKeywordUseCase
    let deleteAllHistoryUseCase: DeleteAllHistoryUseCase
    let getAutoCompletionUseCase: GetAutoCompletionUseCase
    
}
