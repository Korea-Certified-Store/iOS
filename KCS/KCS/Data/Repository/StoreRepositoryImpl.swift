//
//  StoreRepositoryImpl.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import RxSwift
import Alamofire

final class StoreRepositoryImpl: StoreRepository {
    
    private var stores: [[Store]]
    
    init(stores: [[Store]] = []) {
        self.stores = stores
    }
    
    // TODO: 현재 1차원 배열로 오는 로직으로 적용되어 있기 때문에, 2차원 배열 로직으로 변환해야 한다.
    func fetchRefreshStores(
        requestLocation: RequestLocation
    ) -> Observable<[Store]> {
        return Observable<[Store]>.create { observer -> Disposable in
            AF.request(StoreAPI.getStores(location: RequestLocationDTO(
                nwLong: requestLocation.northWest.longitude,
                nwLat: requestLocation.northWest.latitude,
                swLong: requestLocation.southWest.longitude,
                swLat: requestLocation.southWest.latitude,
                seLong: requestLocation.southEast.longitude,
                seLat: requestLocation.southEast.latitude,
                neLong: requestLocation.northEast.longitude,
                neLat: requestLocation.northEast.latitude
            )))
            .responseDecodable(of: StoreResponse.self) { [weak self] response in
                do {
                    switch response.result {
                    case .success(let result):
                        let resultStores = try result.data.map { try $0.toEntity() }
                        self?.stores = [resultStores]
                        observer.onNext(resultStores)
                    case .failure(let error):
                        throw error
                    }
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchStores(count: Int) -> [Store] {
        var fetchResult: [Store] = []
        for index in 0..<count {
            fetchResult.append(contentsOf: stores[index])
        }
        return fetchResult
    }
    
    func getStoreInformation(
        tag: UInt
    ) throws -> Store {
        guard let store = stores.flatMap({ $0 }).first(where: { $0.id == tag }) else { throw StoreRepositoryError.wrongStoreId }
        return store
    }
    
}
