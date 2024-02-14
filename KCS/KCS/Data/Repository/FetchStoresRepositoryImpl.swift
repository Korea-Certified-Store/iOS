//
//  FetchStoresRepositoryImpl.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import RxSwift
import Alamofire

final class FetchStoresRepositoryImpl: FetchStoresRepository {
    
    let storeStorage: StoreStorage
    
    init(storeStorage: StoreStorage) {
        self.storeStorage = storeStorage
    }
    
    func fetchStores(
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
            .responseDecodable(of: RefreshStoreResponse.self) { [weak self] response in
                do {
                    switch response.result {
                    case .success(let result):
                        let resultStores = try result.data.map { try $0.map { try $0.toEntity() } }
                        self?.storeStorage.stores = resultStores.flatMap({ $0 })
                        if isEntire {
                            observer.onNext(FetchStores(
                                fetchCountContent: FetchCountContent(),
                                stores: resultStores.flatMap { $0 }
                            ))
                        } else if let firstIndexStore = resultStores.first {
                            observer.onNext(FetchStores(
                                fetchCountContent: FetchCountContent(maxFetchCount: resultStores.count),
                                stores: firstIndexStore
                            ))
                        } else {
                            observer.onNext(FetchStores(
                                fetchCountContent: FetchCountContent(),
                                stores: []
                            ))
                        }
                    case .failure(let error):
                        if let underlyingError = error.underlyingError as? NSError {
                            switch underlyingError.code {
                            case URLError.notConnectedToInternet.rawValue:
                                observer.onError(ErrorAlertMessage.internet)
                            default:
                                observer.onError(ErrorAlertMessage.server)
                            }
                        }
                    }
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
}