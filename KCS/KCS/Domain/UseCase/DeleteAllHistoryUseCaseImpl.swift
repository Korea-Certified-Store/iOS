//
//  DeleteAllHistoryUseCaseImpl.swift
//  KCS
//
//  Created by 김영현 on 2/14/24.
//

import Foundation

struct DeleteAllHistoryUseCaseImpl: DeleteAllHistoryUseCase {
    
    let repository: SearchKeywordsRepository
    
    func execute() {
        return repository.deleteAllHistory()
    }
    
}
