//
//  GetStoresUseCase.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import RxSwift

protocol GetStoresUseCase {
    
    var repository: FetchStoresRepository { get }
    
    init(repository: FetchStoresRepository)
    
    func execute(
        requestLocation: RequestLocation
    ) -> Observable<FetchStores>

}
