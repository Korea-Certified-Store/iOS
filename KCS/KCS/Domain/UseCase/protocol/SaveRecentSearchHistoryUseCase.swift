//
//  SaveRecentSearchHistoryUseCase.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import RxSwift

protocol SaveRecentSearchHistoryUseCase {
    
    var repository: SaveRecentSearchHistoryRepository { get }
    
    init(repository: SaveRecentSearchHistoryRepository)
    
    func execute(recentSearchKeyword: String)
    
}
