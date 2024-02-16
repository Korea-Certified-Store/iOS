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
        
        func isPointInsideRectangle(rectangle: RequestLocation, point: Location) -> Bool {
            let sideWest = vector(from: rectangle.northWest, to: rectangle.southWest)
            let sideSouth = vector(from: rectangle.southWest, to: rectangle.southEast)
            let sideEast = vector(from: rectangle.southEast, to: rectangle.northEast)
            let sideNorth = vector(from: rectangle.northEast, to: rectangle.northWest)
            
            let vectorFromWest = vector(from: rectangle.northWest, to: point)
            let vectorFromSouth = vector(from: rectangle.southWest, to: point)
            let vectorFromEast = vector(from: rectangle.southEast, to: point)
            let vectorFromNorth = vector(from: rectangle.northEast, to: point)
            
            let crossWest = crossProduct(sideWest, vectorFromWest)
            let crossSouth = crossProduct(sideSouth, vectorFromSouth)
            let crossEast = crossProduct(sideEast, vectorFromEast)
            let crossNorth = crossProduct(sideNorth, vectorFromNorth)
            
            return crossWest * crossSouth > 0 && crossSouth * crossEast > 0 && crossEast * crossNorth > 0
        }

        func crossProduct(_ vector1: Location, _ vector2: Location) -> Double {
            return vector1.longitude * vector2.latitude - vector1.latitude * vector2.longitude
        }

        func vector(from point1: Location, to point2: Location) -> Location {
            return Location(longitude: point2.longitude - point1.longitude, latitude: point2.latitude - point1.latitude)
        }
        
        var result: [Store] = []
        stores.forEach { store in
            if isPointInsideRectangle(
                rectangle: requestLocation,
                point: store.location) {
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

    // 임시 메소드
    func getStoreInformation(location: Location, keyword: String) -> RxSwift.Observable<[KCS.Store]> {
        return Observable<[KCS.Store]>
    }
        
}
