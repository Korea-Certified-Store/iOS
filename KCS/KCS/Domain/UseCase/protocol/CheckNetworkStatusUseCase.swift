//
//  CheckNetworkStatusUseCase.swift
//  KCS
//
//  Created by 김영현 on 2/8/24.
//

import Foundation

protocol CheckNetworkStatusUseCase {
    
    var repository: NetworkRepository { get }
    
    init(repository: NetworkRepository)
    
    func execute() -> Bool
    
}
