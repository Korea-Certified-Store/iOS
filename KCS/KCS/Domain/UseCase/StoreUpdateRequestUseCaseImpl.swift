//
//  StoreUpdateRequestUseCaseImpl.swift
//  KCS
//
//  Created by 조성민 on 2/18/24.
//

import RxSwift

struct StoreUpdateRequestUseCaseImpl: StoreUpdateRequestUseCase {
    
    let repository: StoreUpdateRequestRepository
    
    func execute(type: StoreUpdateRequestType, storeID: Int, content: String) -> Observable<Void> {
        return repository.storeUpdateReqeust(type: type, storeID: storeID, content: content)
    }
    
}
