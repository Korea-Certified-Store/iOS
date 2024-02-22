//
//  DeleteRecentSearchHistoryUseCase.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import Foundation

protocol DeleteRecentSearchHistoryUseCase {
    
    var repository: DeleteRecentSearchHistoryRepository { get }
    
    init(repository: DeleteRecentSearchHistoryRepository)
    
    func execute(index: Int)
    
}
