//
//  StoreRepository.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import RxSwift

protocol StoreRepository {
    
    func fetchRefreshStores(
        requestLocation: RequestLocation
    ) -> Observable<FetchStores>
    
    func fetchStores(count: Int) -> [Store]
    
    func getStoreInformation(
        tag: UInt
    ) throws -> Store
    
    func getStoreByIndex(
        index: Int
    ) throws -> Store
    
}
