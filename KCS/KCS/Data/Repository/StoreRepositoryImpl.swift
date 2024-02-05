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
        requestLocation: RequestLocation,
        isEntire: Bool
    ) -> Observable<FetchStores> {
        return Observable<FetchStores>.create { observer -> Disposable in
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
                        var fetchStores: FetchStores
                        self?.stores = resultStores
                        if isEntire {
                            fetchStores = FetchStores(
                                fetchCountContent: FetchCountContent(),
                                stores: resultStores.flatMap { $0 }
                            )
                        } else {
                            if let firstIndexStore = resultStores.first {
                                fetchStores = FetchStores(
                                    fetchCountContent: FetchCountContent(maxFetchCount: resultStores.count),
                                    stores: firstIndexStore
                                )
                            } else {
                                fetchStores = FetchStores(
                                    fetchCountContent: FetchCountContent(),
                                    stores: []
                                )
                            }
                        }
                        observer.onNext(fetchStores)
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
