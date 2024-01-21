//
//  FetchRefreshStoresUseCaseImplTests.swift
//  KCSUnitTest
//
//  Created by 조성민 on 1/21/24.
//

import XCTest
@testable import KCS
import RxSwift
import RxTest
import RxBlocking

final class FetchRefreshStoresUseCaseImplTests: XCTestCase {

    var fetchRefreshStoresUseCaseImpl: FetchRefreshStoresUseCaseImpl!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        disposeBag = DisposeBag()
        var stores: [Store] = []
        
        for row in 0...10 {
            for column in 0...10 {
                stores.append(
                    Store(
                        id: stores.count,
                        title: "",
                        certificationTypes: [],
                        category: "",
                        address: "",
                        phoneNumber: "",
                        location: Location(
                            longitude: Double(row) * 0.02,
                            latitude: Double(column) * 0.02
                        ),
                        openingHour: [],
                        localPhotos: []
                    )
                )
            }
        }
        fetchRefreshStoresUseCaseImpl = FetchRefreshStoresUseCaseImpl(repository: MockSuccessStoreRepository(stores: stores))
    }
    
    func test_변의_길이가_작은_경우_해당하는_좌표안의_가게들을_재검색하여_불러온다() {
        XCTAssertEqual(
            try fetchRefreshStoresUseCaseImpl.execute(
            requestLocation: RequestLocation(
                northWest: Location(
                    longitude: 0.1 - 0.03,
                    latitude: 0.1
                ),
                southWest: Location(
                    longitude: 0.1,
                    latitude: 0.1 - 0.03
                ),
                southEast: Location(
                    longitude: 0.1 + 0.03,
                    latitude: 0.1
                ),
                northEast: Location(
                    longitude: 0.1,
                    latitude: 0.1 + 0.03
                )
            )
        ).toBlocking().first()?.count, 5)
    }
    
    func test_모든_변의_길이가_기준보다_큰_경우_모두_재조정하여_재검색하여_불러온다() {
        XCTAssertEqual(
            try fetchRefreshStoresUseCaseImpl.execute(
            requestLocation: RequestLocation(
                northWest: Location(
                    longitude: 0.1 - 0.06,
                    latitude: 0.1
                ),
                southWest: Location(
                    longitude: 0.1,
                    latitude: 0.1 - 0.06
                ),
                southEast: Location(
                    longitude: 0.1 + 0.06,
                    latitude: 0.1
                ),
                northEast: Location(
                    longitude: 0.1,
                    latitude: 0.1 + 0.06
                )
            )
        ).toBlocking().first()?.count, 13)
    }
    
    func test_변의_길이가_기준보다_크고_longitude나_latitude가_같은_경우_재조정_예외처리() {
        XCTAssertEqual(
            try fetchRefreshStoresUseCaseImpl.execute(
            requestLocation: RequestLocation(
                northWest: Location(
                    longitude: 0.1 - 0.05,
                    latitude: 0.1 + 0.05
                ),
                southWest: Location(
                    longitude: 0.1 - 0.05,
                    latitude: 0.1 - 0.05
                ),
                southEast: Location(
                    longitude: 0.1 + 0.05,
                    latitude: 0.1 - 0.05
                ),
                northEast: Location(
                    longitude: 0.1 + 0.05,
                    latitude: 0.1 + 0.05
                )
            )
        ).toBlocking().first()?.count, 9)
    }
    
}
