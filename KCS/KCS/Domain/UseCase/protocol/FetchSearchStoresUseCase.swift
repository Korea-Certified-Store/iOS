//
//  FetchSearchStoresUseCase.swift
//  KCS
//
//  Created by 조성민 on 2/9/24.
//

import RxSwift

protocol FetchSearchStoresUseCase {
    
    var repository: StoreRepository { get }
    
    init(repository: StoreRepository)
    
    func execute(
        location: Location,
        keyword: String
    ) -> Observable<[Store]>
    
}
