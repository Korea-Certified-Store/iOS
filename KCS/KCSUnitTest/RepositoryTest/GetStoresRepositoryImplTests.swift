//
//  GetStoresRepositoryImplTests.swift
//  KCSUnitTest
//
//  Created by 조성민 on 2/29/24.
//

import XCTest
@testable import KCS
import RxSwift

final class GetStoresRepositoryImplTestsEntity {
    
    let emptyStoreArray: [Store] = []
    var stores: [Store] = []
    
    init() {
        self.convertToDTO()
    }
    
    func convertToDTO() {
        guard let path = Bundle(for: type(of: self)).url(forResource: "FetchStoresSuccessWithManyStores", withExtension: "json") else {
            return
        }
        guard let jsonString = try? String(contentsOf: path) else {
            return
        }
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        if let data = data,
           let response = try? decoder.decode(RefreshStoreResponse.self, from: data),
           let storesArray = try? response.data.map({ try $0.map { try $0.toEntity() } }) {
            self.stores = storesArray.flatMap( { $0 } )
        } else {
            return
        }
    }
    
}

final class GetStoresRepositoryImplTests: XCTestCase {

    private var getStoresRepository: GetStoresRepository!
    private var storeStorage: StoreStorage!
    private var disposeBag: DisposeBag!
    private var testEntity: GetStoresRepositoryImplTestsEntity!
    
    override func setUp() {
        storeStorage = StoreStorage()
        getStoresRepository = GetStoresRepositoryImpl(storeStorage: storeStorage)
        disposeBag = DisposeBag()
        testEntity = GetStoresRepositoryImplTestsEntity()
    }

    func test_Store가_0개인_경우() {
        // Given
        storeStorage.stores = testEntity.emptyStoreArray
        
        // When
        let result = getStoresRepository.getStores()
        
        // Then
        XCTAssertEqual(result, testEntity.emptyStoreArray)
    }
    
    func test_Store가_1개_이상인_경우() {
        // Given
        storeStorage.stores = testEntity.stores
        
        // When
        let result = getStoresRepository.getStores()
        
        // Then
        XCTAssertEqual(result, testEntity.stores)
    }

}
