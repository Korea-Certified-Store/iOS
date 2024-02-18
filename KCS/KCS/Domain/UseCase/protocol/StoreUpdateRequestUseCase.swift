//
//  StoreUpdateRequestUseCase.swift
//  KCS
//
//  Created by 조성민 on 2/18/24.
//

import RxSwift

protocol StoreUpdateRequestUseCase {
    
    var repository: StoreUpdateRequestRepository { get }
    
    init(repository: StoreUpdateRequestRepository)
    
    func execute(type: String, storeID: Int, content: String) -> Observable<Void>
    
}
