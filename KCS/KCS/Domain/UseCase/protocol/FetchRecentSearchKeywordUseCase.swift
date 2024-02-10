//
//  FetchRecentSearchKeywordUseCase.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import RxSwift

protocol FetchRecentSearchKeywordUseCase {
    
    var repository: SearchKeywordsRepository { get }
    
    init(repository: SearchKeywordsRepository)
    
    func execute() -> Observable<[String]>
    
}
