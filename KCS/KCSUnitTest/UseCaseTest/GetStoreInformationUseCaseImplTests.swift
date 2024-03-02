//
//  GetStoreInformationUseCaseImplTests.swift
//  KCSUnitTest
//
//  Created by 김영현 on 3/2/24.
//

import XCTest
@testable import KCS

struct GetStoreInformationUseCaseImplTestsConstant {
    
    let store = Store(
        id: 1,
        title: "",
        certificationTypes: [.goodPrice],
        category: nil,
        address: "",
        phoneNumber: nil,
        location: Location(longitude: 0, latitude: 0),
        openingHour: [RegularOpeningHours(
            open: BusinessHour(
                day: .monday,
                hour: 0,
                minute: 0
            ),
            close: BusinessHour(
                day: .monday,
                hour: 0,
                minute: 0
            )
        )],
        localPhotos: [""]
    )
    let storeStorage = StoreStorage()
    let storeId: UInt = 1
    let wrongStoreId: UInt = 2
    
}

final class GetStoreInformationUseCaseImplTests: XCTestCase {

    private var constant: GetStoreInformationUseCaseImplTestsConstant!
    private var repository: GetStoresRepository!
    private var getStoreInformationUseCase: GetStoreInformationUseCaseImpl!
    
    override func setUp() {
        constant = GetStoreInformationUseCaseImplTestsConstant()
        repository = StubGetManyStoresRepository(storeStorage: constant.storeStorage)
        getStoreInformationUseCase = GetStoreInformationUseCaseImpl(repository: repository)
    }
    
    func test_id가_같은_가게정보_가져오기_성공한_경우() {
        // Given initial state
        
        // When
        do {
            let result = try getStoreInformationUseCase.execute(tag: constant.storeId)
            // Then
            XCTAssertEqual(result, constant.store)
        } catch {
            XCTFail("id가 같은 가게정보 가져오기 실패")
        }
    }
    
    func test_id가_같은_가게정보_가져오기_실패한_경우() {
        // Given initial state
        
        // When
        do {
            let result = try getStoreInformationUseCase.execute(tag: constant.wrongStoreId)
            // Then
            XCTFail("Error 방출 실패")
        } catch let error as StoreRepositoryError {
            XCTAssertEqual(error, StoreRepositoryError.wrongStoreId)
        } catch {
            XCTFail("Error 방출 실패")
        }
    }

}
