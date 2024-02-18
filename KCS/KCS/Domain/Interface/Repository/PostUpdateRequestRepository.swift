//
//  PostUpdateRequestRepository.swift
//  KCS
//
//  Created by 조성민 on 2/18/24.
//

import RxSwift

protocol PostUpdateRequestRepository {
    
    func postUpdateReqeust(
        type: String,
        storeID: Int,
        content: String
    ) -> Observable<Void>
    
}
