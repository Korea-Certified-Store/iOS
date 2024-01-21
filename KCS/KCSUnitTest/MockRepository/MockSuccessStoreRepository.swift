//
//  MockSuccessStoreRepository.swift
//  KCSUnitTest
//
//  Created by 조성민 on 1/21/24.
//

@testable import KCS
import RxSwift

struct MockSuccessStoreRepository: StoreRepository {
    
    let store: Store
    
    var stores: [Store]
    
    init(stores: [Store] = [], targetTag: Int = 1) {
        self.stores = stores
        self.store = Store(
            id: targetTag, title: "",
            certificationTypes: [],
            category: "",
            address: "",
            phoneNumber: "",
            location: Location(longitude: 0, latitude: 0),
            openingHour: [],
            localPhotos: []
        )
    }
    
    func fetchRefreshStores(requestLocation: KCS.RequestLocation) -> RxSwift.Observable<[KCS.Store]> {
        return .just(stores)
    }
    
    func fetchStores() -> [KCS.Store] {
        return stores
    }
    
    func getStoreInformation(tag: UInt) throws -> KCS.Store {
        return store
    }
    
    func getTargetStore() -> Store {
        return store
    }
    
    func getAllStores() -> [Store] {
        return stores
    }
}
