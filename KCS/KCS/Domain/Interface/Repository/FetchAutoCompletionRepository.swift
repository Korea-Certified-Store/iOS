//
//  FetchAutoCompletionRepository.swift
//  KCS
//
//  Created by 김영현 on 2/17/24.
//

import RxSwift
import Alamofire

protocol FetchAutoCompletionRepository {
    
    var session: Session { get }
    
    func fetchAutoCompletion(
        searchKeyword: String
    ) -> Observable<[String]>
    
}
