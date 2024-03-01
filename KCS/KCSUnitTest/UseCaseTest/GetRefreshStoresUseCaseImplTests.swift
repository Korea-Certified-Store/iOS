//
//  GetRefreshStoresUseCaseImplTests.swift
//  KCSUnitTest
//
//  Created by 김영현 on 3/1/24.
//

import XCTest
@testable import KCS

struct GetRefreshStoresUseCaseImplTestsConstant {
    
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
    var storesStorage = StoreStorage()
    let emptyStore: [Store] = []
    lazy var manyStores: [Store] = [Store](repeating: store, count: 40)
    lazy var someStores: [Store] = [Store](repeating: store, count: 30)
    
}

final class GetRefreshStoresUseCaseImplTests: XCTestCase {
    
    private var constant: GetRefreshStoresUseCaseImplTestsConstant!
    private var repository: GetStoresRepository!
    private var getRefreshStoresUseCase: GetRefreshStoresUseCase!

    override func setUp() {
        constant = GetRefreshStoresUseCaseImplTestsConstant()
    }
    
    func test_storeStorage에_가게가_0개_들어있는_경우() {
        // Given
        constant.storesStorage.stores = constant.emptyStore
        repository = MockGetStoresRepository(storeStorage: constant.storesStorage)
        getRefreshStoresUseCase = GetRefreshStoresUseCaseImpl(repository: repository)
        
        // When
        let result = getRefreshStoresUseCase.execute(fetchCount: 1)
        
        // Then
        XCTAssertEqual(result, constant.emptyStore)
    }
    
    func test_storeStorage에_가게가_여러개이고_일부_가게만을_불러오는_경우() {
        // Given
        constant.storesStorage.stores = constant.manyStores
        repository = MockGetStoresRepository(storeStorage: constant.storesStorage)
        getRefreshStoresUseCase = GetRefreshStoresUseCaseImpl(repository: repository)
        
        // When
        let result = getRefreshStoresUseCase.execute(fetchCount: 2)
        
        // Then
        XCTAssertEqual(result, constant.someStores)
    }
    
    func test_storeStorage에_가게가_여러개이고_모든_가게를_불러오는_경우() {
        // Given
        constant.storesStorage.stores = constant.manyStores
        repository = MockGetStoresRepository(storeStorage: constant.storesStorage)
        getRefreshStoresUseCase = GetRefreshStoresUseCaseImpl(repository: repository)
        
        // When
        let result = getRefreshStoresUseCase.execute(fetchCount: 3)
        
        // Then
        XCTAssertEqual(result, constant.manyStores)
    }
    
}
