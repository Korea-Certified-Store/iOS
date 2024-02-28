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
    let session: Session
    
    init(storeStorage: StoreStorage, session: Session) {
        self.storeStorage = storeStorage
        self.session = session
    }
    
    func fetchSearchStores(location: Location, keyword: String) -> Observable<[Store]> {
        return Observable<[Store]>.create { [weak self] observer -> Disposable in
            self?.session.request(StoreAPI.getSearchStores(searchDTO: SearchDTO(
                currLong: location.longitude,
                currLat: location.latitude,
                searchKeyword: keyword
            )))
            .responseDecodable(of: SearchStoreResponse.self) { [weak self] response in
                do {
                    switch response.result {
                    case .success(let result):
                        let resultStores = try result.data.map { try $0.toEntity() }
                        self?.storeStorage.stores = resultStores
                        observer.onNext(resultStores)
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
