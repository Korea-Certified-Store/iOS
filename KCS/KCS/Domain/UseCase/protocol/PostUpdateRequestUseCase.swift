//
//  PostUpdateRequestUseCase.swift
//  KCS
//
//  Created by 조성민 on 2/18/24.
//

import RxSwift

protocol PostUpdateRequestUseCase {
    
    var repository: PostUpdateReqeustRepository { get }
    
    init(repository: PostUpdateReqeustRepository)
    
    func execute(type: String, storeID: Int, content: String) -> Observable<Void>
    
}
