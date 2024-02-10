//
//  DeleteRecentSearchKeywordUseCase.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import Foundation

protocol DeleteRecentSearchKeywordUseCase {
    
    var repository: SearchKeywordsRepository { get }
    
    init(repository: SearchKeywordsRepository)
    
    func execute(index: Int)
    
}
