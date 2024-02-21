//
//  GetAutoCompletionUseCase.swift
//  KCS
//
//  Created by 김영현 on 2/17/24.
//

import RxSwift

protocol GetAutoCompletionUseCase {
    
    var repository: FetchAutoCompletionRepository { get }
    
    init(repository: FetchAutoCompletionRepository)
    
    func execute(keyword: String) -> Observable<[String]>
    
}
