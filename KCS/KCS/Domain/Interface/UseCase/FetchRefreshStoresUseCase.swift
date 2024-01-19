//
//  FetchRefreshStoresUseCase.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import RxSwift

protocol FetchRefreshStoresUseCase {
    
    var repository: StoreRepository { get }
    
    init(repository: StoreRepository)
    
    func execute(
        northWestLocation: Location,
        southWestLocation: Location,
        southEastLocation: Location,
        northEastLocation: Location
    ) -> Observable<[Store]>

}