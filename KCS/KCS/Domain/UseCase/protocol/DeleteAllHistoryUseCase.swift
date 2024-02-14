//
//  DeleteAllHistoryUseCase.swift
//  KCS
//
//  Created by 김영현 on 2/14/24.
//

import Foundation

protocol DeleteAllHistoryUseCase {
    
    var repository: SearchKeywordsRepository { get }
    
    init(repository: SearchKeywordsRepository)
    
    func execute()
    
}
