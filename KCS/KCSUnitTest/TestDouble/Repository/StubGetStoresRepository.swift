//
//  StubGetStoresRepository.swift
//  KCSUnitTest
//
//  Created by 김영현 on 3/1/24.
//

import Foundation
@testable import KCS

struct StubGetEmptyStoreRepository: GetStoresRepository {
    
    var storeStorage: StoreStorage
    
    func getStores() -> [Store] {
        return []
    }
    
}

struct StubGetManyStoresRepository: GetStoresRepository {
    
    var storeStorage: StoreStorage
    
    func getStores() -> [Store] {
        let location = Location(longitude: 0, latitude: 0)
        let businessHour = BusinessHour(
            day: .monday,
            hour: 0,
            minute: 0
        )
        lazy var store = Store(
            id: 1,
            title: "",
            certificationTypes: [.goodPrice],
            category: nil,
            address: "",
            phoneNumber: nil,
            location: location,
            openingHour: [RegularOpeningHours(
                open: businessHour,
                close: businessHour
            )],
            localPhotos: [""]
        )
        
        return [Store](repeating: store, count: 40)
    }
    
}
