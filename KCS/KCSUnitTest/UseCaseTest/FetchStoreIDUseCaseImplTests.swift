//
//  FetchStoreIDUseCaseImplTests.swift
//  KCSUnitTest
//
//  Created by 조성민 on 3/3/24.
//

import XCTest
@testable import KCS

struct FetchStoreIDUseCaseImplTestsConstant {
    
    let testKeyword = "TestKeyword"
    let dummyStoreIDStorage = StoreIDStorage()
    static let successStoreID = 1
    static let failureStoreID: Int? = nil
    
}

final class FetchStoreIDUseCaseImplTests: XCTestCase {

    private var fetchStoreIDUseCase: FetchStoreIDUseCaseImpl!
    private var constant: FetchStoreIDUseCaseImplTestsConstant!
    private var stubSuccessFetchStoreIDRepository: StubSuccessFetchStoreIDRepository!
    private var stubFailureFetchStoreIDRepository: StubFailureFetchStoreIDRepository!
    
    override func setUp() {
        constant = FetchStoreIDUseCaseImplTestsConstant()
        stubSuccessFetchStoreIDRepository = StubSuccessFetchStoreIDRepository(storage: constant.dummyStoreIDStorage)
        stubFailureFetchStoreIDRepository = StubFailureFetchStoreIDRepository(storage: constant.dummyStoreIDStorage)
    }
    
    func test_ID를_가져오는_것에_성공한_경우() {
        // Given
        fetchStoreIDUseCase = FetchStoreIDUseCaseImpl(repository: stubSuccessFetchStoreIDRepository)
        
        // When
        let result = fetchStoreIDUseCase.execute()
        
        // Then
        XCTAssertEqual(result, FetchStoreIDUseCaseImplTestsConstant.successStoreID)
    }
    
    func test_ID를_가져오는_것에_실패한_경우() {
        // Given
        fetchStoreIDUseCase = FetchStoreIDUseCaseImpl(repository: stubFailureFetchStoreIDRepository)
        
        // When
        let result = fetchStoreIDUseCase.execute()
        
        // Then
        XCTAssertEqual(result, FetchStoreIDUseCaseImplTestsConstant.failureStoreID)
    }

}
