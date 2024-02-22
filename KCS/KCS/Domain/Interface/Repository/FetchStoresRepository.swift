//
//  FetchStoresRepository.swift
//  KCS
//
//  Created by 조성민 on 2/22/24.
//

import RxSwift

protocol FetchStoresRepository {
    
    var storeStorage: StoreStorage { get }
    
    func fetchStores(
        requestLocation: RequestLocation,
        isEntire: Bool
    ) -> Observable<FetchStores>
    
}
