//
//  StoreRepository.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import RxSwift

protocol FetchStoresRepository {
    
    var storeStorage: StoreStorage { get }
    
    func fetchStores(
        requestLocation: RequestLocation,
        isEntire: Bool
    ) -> Observable<FetchStores>
    
}

protocol GetStoresRepository {
    
    var storeStorage: StoreStorage { get }
    
    func getStores(count: Int) -> [Store]
    
}

protocol GetStoreInformationRepository {
    
    var storeStorage: StoreStorage { get }
    
    func getStoreInformation(
        tag: UInt
    ) throws -> Store
    
}

protocol FetchSearchStoresRepository {
    
    var storeStorage: StoreStorage { get }
    
    func fetchSearchStores(
        location: Location,
        keyword: String
    ) -> Observable<[Store]>
    
}
