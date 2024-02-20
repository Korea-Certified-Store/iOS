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
    
    init(storeStorage: StoreStorage) {
        self.storeStorage = storeStorage
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
                            // TODO: else로 알 수 없는 에러 onError, 디버깅용 Error 처리
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
