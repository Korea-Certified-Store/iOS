//
//  StoreRepositoryImpl.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import RxSwift
import Alamofire

final class StoreRepositoryImpl: StoreRepository {
    
    private var stores: [Store] = []
    
    func fetchStores(
        northWestLocation: Location,
        southEastLocation: Location
    ) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            AF.request(StoreAPI.getStores(location: RequestLocationDTO(
                nwLong: northWestLocation.longitude,
                nwLat: northWestLocation.latitude,
                seLong: southEastLocation.longitude,
                seLat: southEastLocation.latitude
            )))
            .responseDecodable(of: StoreResponse.self) { [weak self] response in
                switch response.result {
                case .success(let result):
                    self?.stores = result.data.map { $0.toEntity() }
                    observer.onNext(())
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getStores(
        types: [CertificationType]
    ) -> [Store] {
        return stores.filter { !$0.certificationTypes.filter { types.contains($0) }.isEmpty }
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
