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
    var storeAPI: any Router { get }
    var session: NetworkSession { get }
    
    func fetchStores(
        requestLocation: RequestLocation,
        isEntire: Bool
    ) -> Observable<FetchStores>
    
}
