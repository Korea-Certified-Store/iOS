//
//  FetchStoreIDRepositoryImplTests.swift
//  KCSUnitTest
//
//  Created by 조성민 on 3/1/24.
//

import XCTest
@testable import KCS
import RxSwift

struct FetchStoreIDRepositoryImplTestsConstant {
    
    let storeID: Int = 1
    
}

final class FetchStoreIDRepositoryImplTests: XCTestCase {

    private var fetchStoreIDRepository: FetchStoreIDRepositoryImpl!
    private var storeIDStorage: StoreIDStorage!
    private var constant: FetchStoreIDRepositoryImplTestsConstant!
    
    override func setUp() {
        storeIDStorage = StoreIDStorage()
        fetchStoreIDRepository = FetchStoreIDRepositoryImpl(storage: storeIDStorage)
        constant = FetchStoreIDRepositoryImplTestsConstant()
    }

    func test_storeID가_없는_경우에_fetch_성공한_경우() {
        // Given initial state
        
        // When
        let result = fetchStoreIDRepository.fetchStoreID()
        
        // Then
        XCTAssertNil(result)
    }
    
    func test_storeID가_있는_경우에_fetch_성공한_경우() {
        // Given
        fetchStoreIDRepository.storage.storeID = constant.storeID
        
        // When
        let result = fetchStoreIDRepository.fetchStoreID()
        
        // Then
        XCTAssertEqual(result, constant.storeID)
    }


}
