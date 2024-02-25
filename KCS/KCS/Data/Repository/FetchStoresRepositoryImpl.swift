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
    let storeAPI: StoreAPI<RequestLocationDTO>
    
    init(storeStorage: StoreStorage, storeAPI: StoreAPI<RequestLocationDTO>) {
        self.storeStorage = storeStorage
        self.storeAPI = storeAPI
    }
    
    func fetchStores(
        requestLocation: RequestLocation,
        isEntire: Bool
    ) -> Observable<FetchStores> {
        return Observable<FetchStores>.create { [weak self] observer -> Disposable in
            do {
                guard let self = self else { return Disposables.create() }
                AF.request(try storeAPI.execute(
                    requestValue: RequestLocationDTO(
                        nwLong: requestLocation.northWest.longitude,
                        nwLat: requestLocation.northWest.latitude,
                        swLong: requestLocation.southWest.longitude,
                        swLat: requestLocation.southWest.latitude,
                        seLong: requestLocation.southEast.longitude,
                        seLat: requestLocation.southEast.latitude,
                        neLong: requestLocation.northEast.longitude,
                        neLat: requestLocation.northEast.latitude
                    )
                ))
                .responseDecodable(of: RefreshStoreResponse.self) { [weak self] response in
                    do {
                        switch response.result {
                        case .success(let result):
                            let resultStores = try result.data.map { try $0.map { try $0.toEntity() } }
                            self?.storeStorage.stores = resultStores.flatMap({ $0 })
                            if isEntire {
                                observer.onNext(FetchStores(
                                    fetchCountContent: FetchCountContent(maxFetchCount: 1, fetchCount: 1),
                                    stores: resultStores.flatMap { $0 }
                                ))
                            } else if let firstIndexStore = resultStores.first {
                                observer.onNext(FetchStores(
                                    fetchCountContent: FetchCountContent(maxFetchCount: resultStores.count, fetchCount: 1),
                                    stores: firstIndexStore
                                ))
                            } else {
                                observer.onNext(FetchStores(
                                    fetchCountContent: FetchCountContent(maxFetchCount: 1, fetchCount: 1),
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
                            } else {
                                observer.onError(ErrorAlertMessage.client)
                            }
                        }
                    } catch {
                        observer.onError(error)
                    }
                }
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
}
