//
//  MockFailStoreRepository.swift
//  KCSUnitTest
//
//  Created by 조성민 on 1/21/24.
//

import RxSwift
@testable import KCS
import Alamofire

struct MockFailStoreRepository: StoreRepository {
    
    func fetchRefreshStores(requestLocation: KCS.RequestLocation) -> RxSwift.Observable<[KCS.Store]> {
        return Observable<[KCS.Store]>.create { observer -> Disposable in
            observer.onError(NetworkError.wrongURL)
            return Disposables.create()
        }
    }
    
    func fetchStores() -> [KCS.Store] {
        []
    }
    
    func getStoreInformation(tag: UInt) throws -> KCS.Store {
        throw StoreRepositoryError.wrongStoreId
    }
    
    
}
