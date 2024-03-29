//
//  FetchStoreIDUseCase.swift
//  KCS
//
//  Created by 조성민 on 2/18/24.
//

import RxSwift

protocol FetchStoreIDUseCase {
    
    var repository: FetchStoreIDRepository { get }
    
    init(repository: FetchStoreIDRepository)
    
    func execute() -> Int?
    
}
