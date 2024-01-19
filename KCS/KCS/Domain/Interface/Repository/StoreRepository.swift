//
//  StoreRepository.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import RxSwift

protocol StoreRepository {
    
    func fetchRefreshStores(
        northWestLocation: Location,
        southWestLocation: Location,
        southEastLocation: Location,
        northEastLocation: Location
    ) -> Observable<[Store]>
    
    func fetchStores() -> [Store]
    
    func getStoreInformation(
        tag: UInt
    ) throws -> Store
    
}
