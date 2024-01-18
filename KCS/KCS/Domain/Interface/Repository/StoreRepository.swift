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
        southEastLocation: Location
    ) -> Observable<[Store]>
    
    func fetchStores() -> [Store]
    
    func getStoreInfo(
        tag: UInt
    ) throws -> Store
    
}
