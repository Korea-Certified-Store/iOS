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
    let session: Session
    
    init(storeStorage: StoreStorage, session: Session) {
        self.storeStorage = storeStorage
        self.session = session
    }
    
    func fetchStores(
        requestLocation: RequestLocation
    ) -> Observable<FetchStores> {
        return Observable<FetchStores>.create { [weak self] observer -> Disposable in
            self?.session.request(StoreAPI.getStores(location: RequestLocationDTO(
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
                        if let firstIndexStore = resultStores.first {
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
                        if let underlyingError = error.underlyingError as? NSError,
                           underlyingError.code == URLError.notConnectedToInternet.rawValue {
                            observer.onError(ErrorAlertMessage.internet)
                        } else if let underlyingError = error.underlyingError as? NSError,
                                  underlyingError.code == 13 {
                            observer.onError(ErrorAlertMessage.server)
                        } else {
                            observer.onError(ErrorAlertMessage.client)
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
