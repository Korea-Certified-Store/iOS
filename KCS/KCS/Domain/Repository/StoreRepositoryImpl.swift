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
        
        return NetworkService.shared.getStores(
            location: RequestLocationDTO(
                northWestLocation: LocationDTO(
                    longitude: northWestLocation.longitude, latitude: northWestLocation.longitude
                ),
                southEastLocation: LocationDTO(
                    longitude: southEastLocation.longitude, latitude: southEastLocation.latitude
                )
            )
        )
        .map { stores in
            return stores.map { $0.toEntity() }
        }
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
