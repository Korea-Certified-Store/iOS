//
//  StoreRepositoryImplTests.swift
//  StoreRepositoryImplTests
//
//  Created by 조성민 on 1/18/24.
//

import XCTest
@testable import KCS

final class StoreRepositoryImplTests: XCTestCase {

    var storeRepositoryImpl: StoreRepositoryImpl?
    
    override func setUp() {
        storeRepositoryImpl = StoreRepositoryImpl()
    }

    func test_Store가_없는_경우_getStores_결과는_빈_배열을_반환한다() {
        // given
        storeRepositoryImpl
        // when
        
        // then
        
    }

}
