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
                        let resultStores = try result.data.map { try $0.map { try $0.toEntity() } }
                        self?.stores = resultStores
                        if let firstIndexStore = resultStores.first {
                            observer.onNext(firstIndexStore)
                        } else {
                            observer.onError(JSONContentsError.bundleRead)
                        }
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
        for index in 0..<count + 1 {
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
