//
//  FetchStoresRepository.swift
//  KCS
//
//  Created by 조성민 on 2/22/24.
//

import RxSwift
import Alamofire

protocol FetchStoresRepository {
    
    var storeStorage: StoreStorage { get }
    var session: Session { get }
    
    func fetchStores(
        requestLocation: RequestLocation
    ) -> Observable<FetchStores>
    
}
