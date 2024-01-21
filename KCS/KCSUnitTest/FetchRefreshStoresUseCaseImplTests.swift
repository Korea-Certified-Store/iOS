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
    var center: Location!
    
    override func setUp() {
        disposeBag = DisposeBag()
        var stores: [Store] = []
        
        for row in 0..<10 {
            for column in 0..<10 {
                stores.append(
                    Store(
                        id: stores.count,
                        title: "",
                        certificationTypes: [],
                        category: "",
                        address: "",
                        phoneNumber: "",
                        location: Location(
                            longitude: Double(row) * 0.01,
                            latitude: Double(column) * 0.01
                        ),
                        openingHour: [],
                        localPhotos: []
                    )
                )
            }
        }
        center = Location(longitude: (0 + 0.01 * 9) / 2.0, latitude: (0 + 0.01 * 9) / 2.0)
        fetchRefreshStoresUseCaseImpl = FetchRefreshStoresUseCaseImpl(repository: MockSuccessStoreRepository(stores: stores))
    }
    
    func test_변의_길이가_작은_경우_해당하는_좌표안의_가게들을_재검색하여_불러온다() {
        XCTAssertEqual(
            try fetchRefreshStoresUseCaseImpl.execute(
            requestLocation: RequestLocation(
                northWest: Location(
                    longitude: center.longitude + 0.01,
                    latitude: center.latitude - 0.01
                ),
                southWest: Location(
                    longitude: center.longitude - 0.01,
                    latitude: center.latitude - 0.01
                ),
                southEast: Location(
                    longitude: center.longitude - 0.01,
                    latitude: center.latitude + 0.01
                ),
                northEast: Location(
                    longitude: center.longitude + 0.01,
                    latitude: center.latitude + 0.01
                )
            )
        ).toBlocking().first()?.count, 4)
    }
    
    func test_세로_변의_길이가_기준보다_크고_가로_변의_길이가_작은_경우_세로만_줄여서_가게들을_재검색하여_불러온다() {
        XCTAssertEqual(
            try fetchRefreshStoresUseCaseImpl.execute(
            requestLocation: RequestLocation(
                northWest: Location(
                    longitude: 0.09,
                    latitude: center.latitude - 0.01
                ),
                southWest: Location(
                    longitude: 0,
                    latitude: center.latitude - 0.01
                ),
                southEast: Location(
                    longitude: 0,
                    latitude: center.latitude + 0.01
                ),
                northEast: Location(
                    longitude: 0.09,
                    latitude: center.latitude + 0.01
                )
            )
        ).toBlocking().first()?.count, 14)
    }
    
    func test_모든_변의_길이가_기준보다_큰_경우_모두_재조정하여_재검색하여_불러온다() {
        XCTAssertEqual(
            try fetchRefreshStoresUseCaseImpl.execute(
            requestLocation: RequestLocation(
                northWest: Location(
                    longitude: 0.09,
                    latitude: 0
                ),
                southWest: Location(
                    longitude: 0,
                    latitude: 0
                ),
                southEast: Location(
                    longitude: 0,
                    latitude: 0.09
                ),
                northEast: Location(
                    longitude: 0.09,
                    latitude: 0.09
                )
            )
        ).toBlocking().first()?.count, 49)
    }
    
    func test_변의_길이가_기준보다_크고_longitude가_같은_경우_재조정_예외처리() {
        
    }
    
    func test_변의_길이가_기준보다_크고_latitude가_같은_경우_재조정_예외처리() {
        
    }
    
}
