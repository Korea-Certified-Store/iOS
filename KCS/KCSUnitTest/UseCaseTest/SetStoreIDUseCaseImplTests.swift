//
//  SetStoreIDUseCaseImplTests.swift
//  KCSUnitTest
//
//  Created by 김영현 on 3/3/24.
//

import XCTest
@testable import KCS

struct SetStoreIDUseCaseImplTestsConstant {
    
    let storeIDStorage = StoreIDStorage()
    let resultID: Int = 3
    
}

final class SetStoreIDUseCaseImplTests: XCTestCase {
    
    private var constant: SetStoreIDUseCaseImplTestsConstant!
    private var setStoreIDUseCase: SetStoreIDUseCaseImpl!

    override func setUp() {
        constant = SetStoreIDUseCaseImplTestsConstant()
        setStoreIDUseCase = SetStoreIDUseCaseImpl(storage: constant.storeIDStorage)
    }
    
    func test_가게_ID정보가_저장되는_경우() {
        // Given initial state
        
        // When
        setStoreIDUseCase.execute(id: 3)
        
        // Then
        XCTAssertEqual(setStoreIDUseCase.storage.storeID, constant.resultID)
    }

}
