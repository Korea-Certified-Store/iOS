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
        
        dump(requestLocation)
        var result: [Store] = []
        stores.forEach { store in
            if requestLocation.northWest.longitude > store.location.longitude
                && requestLocation.northWest.latitude < store.location.latitude
                && requestLocation.northEast.longitude > store.location.longitude
                && requestLocation.northEast.latitude > store.location.latitude
                && requestLocation.southWest.longitude < store.location.longitude
                && requestLocation.southWest.latitude < store.location.latitude
                && requestLocation.southEast.longitude < store.location.longitude
                && requestLocation.southEast.latitude > store.location.latitude {
                result.append(store)
            }
        }
        
        return .just(result)
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
