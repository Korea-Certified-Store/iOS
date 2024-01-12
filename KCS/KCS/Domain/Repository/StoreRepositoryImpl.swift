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
        return Observable<[Store]>.create { observer -> Disposable in
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
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func fetchStoresInMockJSON() throws -> [Store] {
        guard let json = Bundle.main.url(forResource: "MockStoreResponse", withExtension: "json") else {
            throw JSONContentsError.bundleRead
        }
        let data = try Data(contentsOf: json)
        let decodedData = try JSONDecoder().decode(StoreResponse.self, from: data)
        
        return decodedData.data.map { store in
            store.toEntity()
        }
    }
    
}
