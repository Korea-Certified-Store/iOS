//
//  FetchRefreshStoresUseCaseImpl.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import RxSwift

struct FetchRefreshStoresUseCaseImpl: FetchRefreshStoresUseCase {
    
    let repository: StoreRepository
    
    func execute(
        northWestLocation: Location,
        southWestLocation: Location,
        southEastLocation: Location,
        northEastLocation: Location
    ) -> Observable<[Store]> {
        return repository.fetchRefreshStores(
            northWestLocation: northWestLocation,
            southWestLocation: southWestLocation,
            southEastLocation: southEastLocation,
            northEastLocation: northEastLocation
        )
    }
    
}
