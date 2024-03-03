//
//  SetStoreIDUseCaseImplTests.swift
//  KCSUnitTest
//
//  Created by 김영현 on 3/3/24.
//

import XCTest
@testable import KCS

struct SetStoreIDUseCaseImplTestsConstant {
    
    let DummystoreIDStorage = StoreIDStorage()
    let testStoreID: Int = 3
    let resultExecuteCount: Int = 1
    
}

final class SetStoreIDUseCaseImplTests: XCTestCase {
    
    private var constant: SetStoreIDUseCaseImplTestsConstant!
    private var repository: SpySetStoreIDRepository!
    private var setStoreIDUseCase: SetStoreIDUseCaseImpl!

    override func setUp() {
        constant = SetStoreIDUseCaseImplTestsConstant()
        repository = SpySetStoreIDRepository(storage: constant.DummystoreIDStorage)
        setStoreIDUseCase = SetStoreIDUseCaseImpl(repository: repository)
    }
    
    func test_가게_ID정보가_저장되는_경우() {
        // Given initial state
        
        // When
        setStoreIDUseCase.execute(id: constant.testStoreID)
        
        // Then
        XCTAssertEqual(repository.executeCount, constant.resultExecuteCount)
    }

}
