//
//  FetchSearchStoresRepositoryImpl.swift
//  KCS
//
//  Created by 김영현 on 2/11/24.
//

import RxSwift
import Alamofire

final class FetchSearchStoresRepositoryImpl: FetchSearchStoresRepository {
    
    let storeStorage: StoreStorage
    let storeAPI: any Router
    let session: Session
    
    init(storeStorage: StoreStorage, storeAPI: any Router, session: Session) {
        self.storeStorage = storeStorage
        self.storeAPI = storeAPI
        self.session = session
    }
    
    func fetchSearchStores(location: Location, keyword: String) -> Observable<[Store]> {
        return Observable<[Store]>.create { [weak self] observer -> Disposable in
            do {
                guard let self = self else { return Disposables.create() }
                try storeAPI.execute(
                    requestValue: SearchDTO(
                        currLong: location.longitude,
                        currLat: location.latitude,
                        searchKeyword: keyword
                    )
                )
                session.request(storeAPI)
                .responseDecodable(of: SearchStoreResponse.self) { [weak self] response in
                    do {
                        switch response.result {
                        case .success(let result):
                            let resultStores = try result.data.map { try $0.toEntity() }
                            self?.storeStorage.stores = resultStores
                            observer.onNext(resultStores)
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
