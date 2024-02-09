//
//  SaveRecentSearchKeywordUseCase.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import RxSwift

protocol SaveRecentSearchKeywordUseCase {
    
    var repository: SearchKeywordsRepository { get }
    
    init(repository: SearchKeywordsRepository)
    
    func execute(recentSearchKeyword: RecentSearchKeyword)
    
}
