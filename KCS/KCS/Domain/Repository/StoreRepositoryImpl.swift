//
//  StoreRepositoryImpl.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import RxSwift
import Alamofire

struct StoreRepositoryImpl: StoreRepository {
    
    func fetchStores(
        northWestLocation: Location,
        southEastLocation: Location
    ) -> Observable<[Store]> {
        let observable =  Observable<[Store]>.create { observer -> Disposable in
            AF.request(StoreAPI.getStores(location: RequestLocationDTO(
                nwLong: northWestLocation.longitude,
                nwLat: northWestLocation.latitude,
                seLong: southEastLocation.longitude,
                seLat: southEastLocation.latitude
            )))
            .responseDecodable(of: StoreResponse.self) { response in
                switch response.result {
                case .success(let result):
                    observer.onNext(result.data.map { $0.toEntity() })
                case .failure(let error):
                    dump(error)
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
        
        return observable
    }
    
    func fetchStoresInMockJSON() -> Observable<[Store]> {
        var resultStores: [Store] = []
        guard let json = Bundle.main.url(forResource: "MockStoreResponse", withExtension: "json") else {
            return .empty()
        }
        do {
            let data = try Data(contentsOf: json)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(StoreResponse.self, from: data)
            
            let stores = decodedData.data.map { store in
                store.toEntity()
            }
            resultStores = stores
            
        } catch let error {
            dump(error)
            return .empty()
        }
        
        return .just(resultStores)
    }
    
}
