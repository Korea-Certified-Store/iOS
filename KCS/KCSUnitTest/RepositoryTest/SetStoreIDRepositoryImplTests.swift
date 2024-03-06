//
//  SetStoreIDRepositoryImplTests.swift
//  KCSUnitTest
//
//  Created by 김영현 on 3/3/24.
//

import XCTest
@testable import KCS

struct SetStoreIDRepositoryImplTestsConstant {
    
    let fakeStoreIDStorage = StoreIDStorage()
    let storeID: Int = 1
    
}

final class SetStoreIDRepositoryImplTests: XCTestCase {
    
    private var constant: SetStoreIDRepositoryImplTestsConstant!
    private var setStoreIDRepository: SetStoreIDRepositoryImpl!

    override func setUp() {
        constant = SetStoreIDRepositoryImplTestsConstant()
        setStoreIDRepository = SetStoreIDRepositoryImpl(storage: constant.fakeStoreIDStorage)
    }
    
    func test_가게_ID_저장을_하는_경우() {
        // Given initial state
        
        // When
        setStoreIDRepository.setStoreID(id: constant.storeID)
        
        //Then
        XCTAssertEqual(setStoreIDRepository.storage.storeID, constant.storeID)
    }

}
