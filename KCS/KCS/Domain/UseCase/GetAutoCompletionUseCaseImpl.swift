//
//  GetAutoCompletionUseCaseImpl.swift
//  KCS
//
//  Created by 김영현 on 2/17/24.
//

import RxSwift

struct GetAutoCompletionUseCaseImpl: GetAutoCompletionUseCase {
    
    let repository: FetchAutoCompletionRepository
    
    func execute(keyword: String) -> Observable<[String]> {
        return repository.fetchAutoCompletion(searchKeyword: keyword)
    }
}
