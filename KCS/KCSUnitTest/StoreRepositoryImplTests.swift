//
//  StoreRepositoryImplTests.swift
//  StoreRepositoryImplTests
//
//  Created by 조성민 on 1/18/24.
//

import XCTest
@testable import KCS

final class StoreRepositoryImplTests: XCTestCase {

    var storeRepositoryImpl: StoreRepositoryImpl!
    
    override func setUp() {
        storeRepositoryImpl = StoreRepositoryImpl()
    }

    func test_Store가_없는_경우_getStores_결과는_빈_배열을_반환한다() {
        storeRepositoryImpl = StoreRepositoryImpl(stores: [])
        
        XCTAssertTrue(storeRepositoryImpl.fetchStores().isEmpty)
    }
    
    func test_Store가_있는_경우_getStores_결과는_Store_전체_배열을_반환한다() {
        let stores = [
            Store(id: 0, title: "", certificationTypes: [], category: "", address: "", phoneNumber: "", location: Location(longitude: 0, latitude: 0), openingHour: []),
            Store(id: 1, title: "", certificationTypes: [], category: "", address: "", phoneNumber: "", location: Location(longitude: 0, latitude: 0), openingHour: []),
            Store(id: 2, title: "", certificationTypes: [], category: "", address: "", phoneNumber: "", location: Location(longitude: 0, latitude: 0), openingHour: []),
            Store(id: 3, title: "", certificationTypes: [], category: "", address: "", phoneNumber: "", location: Location(longitude: 0, latitude: 0), openingHour: []),
        ]
        storeRepositoryImpl = StoreRepositoryImpl(stores: stores)
        
        XCTAssertEqual(storeRepositoryImpl.fetchStores(), stores)
    }
    
//    func test_fetchRefreshStores_결과는_에러가_발생하지_않는다() {
//        
//        storeRepositoryImpl.fetchRefreshStores(
//            northWestLocation: Location(longitude: -180, latitude: -90),
//            southEastLocation: Location(longitude: +180, latitude: +90)
//        )
//        .catch({ error in
//            
//        })
//    }
    
}
