//
//  FetchSearchStoresRepository.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import RxSwift

protocol FetchSearchStoresRepository {
    
    var storeStorage: StoreStorage { get }
    var storeAPI: StoreAPI<SearchDTO> { get }
    
    func fetchSearchStores(
        location: Location,
        keyword: String
    ) -> Observable<[Store]>
    
}
