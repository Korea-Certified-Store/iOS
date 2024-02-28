//
//  FetchSearchStoresRepositoryImplTests.swift
//  KCSUnitTest
//
//  Created by 조성민 on 2/29/24.
//

import XCTest
@testable import KCS
import RxSwift
import Alamofire
import RxBlocking

final class FetchSearchStoresRepositoryImplTestsEntity {
    
    var emptyStoreArray: [Store] = []
    var oneStore: [Store] = []
    var manyStores: [Store] = []
    let mockKeyword: String = "keyword"
    let mockLocation: Location = Location(longitude: 0, latitude: 0)
    
    enum SearchCase: CaseIterable {
        case noStore
        case oneStore
        case manyStores
        
        var fileName: String {
            switch self {
            case .noStore:
                return "FetchSearchStoresSuccessWithNoStore"
            case .oneStore:
                return "FetchSearchStoresSuccessWithOneStore"
            case .manyStores:
                return "FetchSearchStoresSuccessWithManyStores"
            }
        }
    }
    
    init() {
        SearchCase.allCases.forEach( { [weak self] searchCase in
            self?.convertToDTO(searchCase: searchCase
        ) } )
    }
    
    func convertToDTO(searchCase: SearchCase) {
        guard let path = Bundle(for: type(of: self)).url(forResource: searchCase.fileName, withExtension: "json") else {
            return
        }
        guard let jsonString = try? String(contentsOf: path) else {
            return
        }
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        if let data = data,
           let response = try? decoder.decode(SearchStoreResponse.self, from: data),
           let storesArray = try? response.data.map({ try $0.toEntity() }) {
            switch searchCase {
            case .noStore:
                emptyStoreArray = storesArray
            case .oneStore:
                oneStore = storesArray
            case .manyStores:
                manyStores = storesArray
            }
        } else {
            return
        }
    }
    
}

final class FetchSearchStoresRepositoryImplTests: XCTestCase {

    private var fetchSearchStoresRepository: FetchSearchStoresRepository!
    private var storeStorage: StoreStorage!
    private var disposeBag: DisposeBag!
    private var testEntity: FetchSearchStoresRepositoryImplTestsEntity!
    
    override func setUp() {
        let session: Session = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [MockURLProtocol.self]
                return configuration
            }()
            return Session(configuration: configuration)
        }()
        
        storeStorage = StoreStorage()
        fetchSearchStoresRepository = FetchSearchStoresRepositoryImpl(
            storeStorage: storeStorage,
            session: session
        )
        disposeBag = DisposeBag()
        testEntity = FetchSearchStoresRepositoryImplTestsEntity()
    }

    func test_Store_0개를_받아_성공한_경우() {
        MockURLProtocol.responseWithStatusCode(code: 200)
        MockURLProtocol.setResponseFile(type: .fetchSearchStoresSuccessWithNoStore)
        do {
            let result = try fetchSearchStoresRepository.fetchSearchStores(
                location: testEntity.mockLocation,
                keyword: testEntity.mockKeyword
            ).toBlocking().first()
            
            XCTAssertEqual(fetchSearchStoresRepository.storeStorage.stores, testEntity.emptyStoreArray)
            XCTAssertEqual(result, testEntity.emptyStoreArray)
        } catch {
            XCTFail("to Entity 실패")
        }
    }
    
    func test_Store_1개를_받아_성공한_경우() {
        MockURLProtocol.responseWithStatusCode(code: 200)
        MockURLProtocol.setResponseFile(type: .fetchSearchStoresSuccessWithOneStore)
        do {
            let result = try fetchSearchStoresRepository.fetchSearchStores(
                location: testEntity.mockLocation,
                keyword: testEntity.mockKeyword
            ).toBlocking().first()
            
            XCTAssertEqual(fetchSearchStoresRepository.storeStorage.stores, testEntity.oneStore)
            XCTAssertEqual(result, testEntity.oneStore)
        } catch {
            XCTFail("to Entity 실패")
        }
    }
    
    func test_Store_2개_이상을_받아_성공한_경우() {
        MockURLProtocol.responseWithStatusCode(code: 200)
        MockURLProtocol.setResponseFile(type: .fetchSearchStoresSuccessWithManyStores)
        do {
            let result = try fetchSearchStoresRepository.fetchSearchStores(
                location: testEntity.mockLocation,
                keyword: testEntity.mockKeyword
            ).toBlocking().first()
            
            XCTAssertEqual(fetchSearchStoresRepository.storeStorage.stores, testEntity.manyStores)
            XCTAssertEqual(result, testEntity.manyStores)
        } catch {
            XCTFail("to Entity 실패")
        }
    }
        
    func test_인터넷_연결에_실패한_경우() {
        MockURLProtocol.responseWithFailure(error: .noInternetConnection)
        
        let result = fetchSearchStoresRepository.fetchSearchStores(
            location: testEntity.mockLocation,
            keyword: testEntity.mockKeyword
        ).toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTFail("Error 방출 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? ErrorAlertMessage, ErrorAlertMessage.internet)
        }
    }
    
    func test_서버_연결에_실패한_경우() {
        MockURLProtocol.responseWithFailure(error: .noServerConnection)
        
        let result = fetchSearchStoresRepository.fetchSearchStores(
            location: testEntity.mockLocation,
            keyword: testEntity.mockKeyword
        ).toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTFail("Error 방출 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? ErrorAlertMessage, ErrorAlertMessage.server)
        }
    }
    
    func test_Day_toEntity_실패한_경우() {
        MockURLProtocol.responseWithStatusCode(code: 200)
        MockURLProtocol.setResponseFile(type: .fetchSearchStoresFailureWithWrongDay)
        
        let result = fetchSearchStoresRepository.fetchSearchStores(
            location: testEntity.mockLocation,
            keyword: testEntity.mockKeyword
        ).toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTFail("Error 방출 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? JSONContentsError, JSONContentsError.wrongDay)
        }
    }
    
    func test_Certification_toEntity_실패한_경우() {
        MockURLProtocol.responseWithStatusCode(code: 200)
        MockURLProtocol.setResponseFile(type: .fetchSearchStoresFailureWithWrongCertification)
        
        let result = fetchSearchStoresRepository.fetchSearchStores(
            location: testEntity.mockLocation,
            keyword: testEntity.mockKeyword
        ).toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTFail("Error 방출 실패")
        case .failed(_, let error):
            dump(error)
            XCTAssertEqual(error as? JSONContentsError, JSONContentsError.wrongCertificationType)
        }
    }
    
    func test_Alamofire_통신에_실패한_경우() {
        MockURLProtocol.responseWithFailure(error: .alamofireError)
        
        let result = fetchSearchStoresRepository.fetchSearchStores(
            location: testEntity.mockLocation,
            keyword: testEntity.mockKeyword
        ).toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTFail("Error 방출 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? ErrorAlertMessage, ErrorAlertMessage.client)
        }
    }
    
}
