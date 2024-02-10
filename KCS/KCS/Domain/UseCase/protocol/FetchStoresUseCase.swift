//
//  FetchStoresUseCase.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import RxSwift

protocol FetchStoresUseCase {
    
    var repository: FetchStoresRepository { get }
    
    init(repository: FetchStoresRepository)
    
    func execute(
        requestLocation: RequestLocation,
        isEntire: Bool
    ) -> Observable<FetchStores>

}
