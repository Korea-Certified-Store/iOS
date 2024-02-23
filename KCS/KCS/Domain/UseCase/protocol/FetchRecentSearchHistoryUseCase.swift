//
//  FetchRecentSearchHistoryUseCase.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import RxSwift

protocol FetchRecentSearchHistoryUseCase {
    
    var repository: FetchRecentSearchHistoryRepository { get }
    
    init(repository: FetchRecentSearchHistoryRepository)
    
    func execute() -> Observable<[String]>
    
}
