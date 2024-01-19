//
//  FetchStoresUseCaseImplTests.swift
//  KCSUnitTest
//
//  Created by 조성민 on 1/19/24.
//

import XCTest
@testable import KCS
import RxSwift
import RxTest
import RxBlocking

final class FetchStoresUseCaseImplTests: XCTestCase {

    var fetchStoresUseCaseImpl: FetchStoresUseCaseImpl!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        disposeBag = DisposeBag()
    }

    func test_Store가_없으면_execute의_결과는_빈_배열을_반환한다() {
        fetchStoresUseCaseImpl = FetchStoresUseCaseImpl(
            repository: StoreRepositoryImpl(stores: [])
        )
        let result = fetchStoresUseCaseImpl.execute()
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_Store가_있으면_execute의_결과는_모든_Store를_포함하는_배열을_반환한다() {
        let stores = [
            Store(
                id: 0, title: "",
                certificationTypes: [],
                category: "",
                address: "",
                phoneNumber: "",
                location: Location(longitude: 0, latitude: 0),
                openingHour: [],
                localPhotos: []
            ),
            Store(
                id: 1, title: "",
                certificationTypes: [],
                category: "",
                address: "",
                phoneNumber: "",
                location: Location(longitude: 0, latitude: 0),
                openingHour: [],
                localPhotos: []
            ),
            Store(
                id: 2, title: "",
                certificationTypes: [],
                category: "",
                address: "",
                phoneNumber: "",
                location: Location(longitude: 0, latitude: 0),
                openingHour: [],
                localPhotos: []
            ),
            Store(
                id: 3, title: "",
                certificationTypes: [],
                category: "",
                address: "",
                phoneNumber: "",
                location: Location(longitude: 0, latitude: 0),
                openingHour: [],
                localPhotos: []
            )
        ]
        fetchStoresUseCaseImpl = FetchStoresUseCaseImpl(
            repository: StoreRepositoryImpl(stores: stores)
        )
        let result = fetchStoresUseCaseImpl.execute()
        
        XCTAssertEqual(result, stores)
    }

}
