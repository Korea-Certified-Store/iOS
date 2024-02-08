//
//  StoreRepositoryImpl.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import RxSwift
import Alamofire

final class StoreRepositoryImpl: StoreRepository {
    
    private var stores: [Store]
    
    init(stores: [Store] = []) {
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
            .responseDecodable(of: RefreshStoreResponse.self) { [weak self] response in
                do {
                    switch response.result {
                    case .success(let result):
                        let resultStores = try result.data.map { try $0.map { try $0.toEntity() } }
                        self?.stores = resultStores.flatMap({ $0 })
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
    
    func fetchStores(count: Int) -> [Store] {
        if stores.isEmpty { return [] }
        var fetchResult: [Store] = []
        var storeCount = count * 15
        if storeCount > stores.count {
            storeCount = stores.count
        }
        for index in 0..<storeCount {
            fetchResult.append(stores[index])
        }
        return fetchResult
    }
    
    func getStoreInformation(
        tag: UInt
    ) throws -> Store {
        guard let store = stores.first(where: { $0.id == tag }) else { throw StoreRepositoryError.wrongStoreId }
        return store
    }
    
    func fetchSearchStores(location: Location, keyword: String) -> Observable<[Store]> {
        return Observable<[Store]>.create { observer -> Disposable in
            AF.request(StoreAPI.getSearchStores(searchDTO: SearchDTO(
                currLong: location.longitude,
                currLat: location.latitude,
                searchKeyword: keyword
            )))
            .responseDecodable(of: SearchStoreResponse.self) { [weak self] response in
                do {
                    switch response.result {
                    case .success(let result):
                        let resultStores = try result.data.map { try $0.toEntity() }
                        // TODO: 일차원 배열 가게들 저장
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
