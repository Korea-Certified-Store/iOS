//
//  FetchSearchStoresRepository.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import RxSwift
import Alamofire

protocol FetchSearchStoresRepository {
    
    var storeStorage: StoreStorage { get }
    var session: Session { get }
    
    func fetchSearchStores(
        location: Location,
        keyword: String
    ) -> Observable<[Store]>
    
}
