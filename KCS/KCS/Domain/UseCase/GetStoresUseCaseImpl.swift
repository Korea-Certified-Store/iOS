//
//  GetStoresUseCaseImpl.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import RxSwift

struct GetStoresUseCaseImpl {
    
    private let repository: StoreRepository
    
    init(repository: StoreRepository) {
        self.repository = repository
    }
    
    func execute(
        northWestLocation: Location,
        southEastLocation: Location
    ) -> Observable<[Store]> {
        return repository.fetchStores(
            northWestLocation: northWestLocation,
            southEastLocation: southEastLocation
        )
    }
    
}
