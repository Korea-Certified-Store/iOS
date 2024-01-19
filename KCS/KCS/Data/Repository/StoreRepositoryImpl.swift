//
//  StoreRepositoryImpl.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import RxSwift
import Alamofire

final class StoreRepositoryImpl: StoreRepository {
    
    private var stores: [Store]
    
    init(stores: [Store] = []) {
        self.stores = stores
    }
    
    func fetchRefreshStores(
        northWestLocation: Location,
        southWestLocation: Location,
        southEastLocation: Location,
        northEastLocation: Location
    ) -> Observable<[Store]> {
        return Observable<[Store]>.create { observer -> Disposable in
            AF.request(StoreAPI.getStores(location: RequestLocationDTO(
                nwLong: northWestLocation.longitude,
                nwLat: northWestLocation.latitude,
                swLong: southWestLocation.longitude,
                swLat: southWestLocation.latitude,
                seLong: southEastLocation.longitude,
                seLat: southEastLocation.latitude,
                neLong: northEastLocation.longitude,
                neLat: northEastLocation.latitude
            )))
            .responseDecodable(of: StoreResponse.self) { [weak self] response in
                switch response.result {
                case .success(let result):
                    let resultStores = result.data.map { $0.toEntity() }
                    self?.stores = resultStores
                    observer.onNext(resultStores)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func fetchStores() -> [Store] {
        return stores
    }
    
    func getStoreInfo(
        tag: UInt
    ) throws -> Store {
        guard let store = stores.first(where: { $0.id == tag }) else { throw StoreRepoError.wrongStoreId }
        return store
    }
    
}
