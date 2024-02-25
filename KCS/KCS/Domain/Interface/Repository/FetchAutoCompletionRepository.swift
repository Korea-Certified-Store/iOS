//
//  FetchAutoCompletionRepository.swift
//  KCS
//
//  Created by 김영현 on 2/17/24.
//

import RxSwift

protocol FetchAutoCompletionRepository {
    
    var storeAPI: any Router { get }
    
    func fetchAutoCompletion(
        searchKeyword: String
    ) -> Observable<[String]>
    
}
