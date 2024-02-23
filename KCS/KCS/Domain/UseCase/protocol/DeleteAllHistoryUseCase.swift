//
//  DeleteAllHistoryUseCase.swift
//  KCS
//
//  Created by 김영현 on 2/14/24.
//

import Foundation

protocol DeleteAllHistoryUseCase {
    
    var repository: DeleteAllHistoryRepository { get }
    
    init(repository: DeleteAllHistoryRepository)
    
    func execute()
    
}
