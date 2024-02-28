//
//  FetchStoresRepositoryImplTests.swift
//  KCSUnitTest
//
//  Created by 조성민 on 2/26/24.
//

import XCTest
@testable import KCS
import RxSwift
import Alamofire
import RxBlocking

final class FetchStoresRepositoryImplTestsEntity {
    
    let emptyStoreArray: [Store] = []
    
    var stores: [[Store]] = []
    var flattenStores: [Store] = []
    
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
            self.stores = storesArray
            self.flattenStores = storesArray.flatMap( { $0 } )
        } else {
            return 
        }
    }
    
}

final class FetchStoresRepositoryImplTests: XCTestCase {

    private var fetchStoresRepository: FetchStoresRepositoryImpl!
    private var disposeBag: DisposeBag!
    private var mockRequestLocation: RequestLocation!
    private var testEntity: FetchStoresRepositoryImplTestsEntity!
    
    override func setUp() {
        let session: Session = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [MockURLProtocol.self]
                return configuration
            }()
            return Session(configuration: configuration)
        }()
        
        fetchStoresRepository = FetchStoresRepositoryImpl(
            storeStorage: StoreStorage(),
            session: session
        )
        disposeBag = DisposeBag()
        
        mockRequestLocation = RequestLocation(
            northWest: Location(longitude: 0, latitude: 0),
            southWest: Location(longitude: 0, latitude: 0),
            southEast: Location(longitude: 0, latitude: 0),
            northEast: Location(longitude: 0, latitude: 0)
        )
        testEntity = FetchStoresRepositoryImplTestsEntity()
    }
    
    func test_Store_0개를_받아_성공한_경우() {
        MockURLProtocol.responseWithStatusCode(code: 200)
        MockURLProtocol.setResponseFile(type: .fetchStoresSuccessWithZeroStore)
        do {
            let result = try fetchStoresRepository.fetchStores(requestLocation: mockRequestLocation).toBlocking().first()
            
            XCTAssertEqual(fetchStoresRepository.storeStorage.stores, testEntity.emptyStoreArray)
            XCTAssertTrue(result?.fetchCountContent.maxFetchCount == 1)
            XCTAssertTrue(result?.fetchCountContent.fetchCount == 1)
            XCTAssertEqual(result?.stores, testEntity.emptyStoreArray)
        } catch {
            XCTFail("toEntity 실패")
        }
    }
    
    func test_Store_1개_이상을_받아_성공한_경우() {
        MockURLProtocol.responseWithStatusCode(code: 200)
        MockURLProtocol.setResponseFile(type: .fetchStoresSuccessWithManyStores)
        do {
            let result = try fetchStoresRepository.fetchStores(requestLocation: mockRequestLocation).toBlocking().first()
            XCTAssertEqual(fetchStoresRepository.storeStorage.stores, testEntity.flattenStores)
            XCTAssertTrue(result?.fetchCountContent.maxFetchCount == 4)
            XCTAssertTrue(result?.fetchCountContent.fetchCount == 1)
            XCTAssertEqual(result?.stores, testEntity.stores.first)
        } catch {
            XCTFail("toEntity 실패")
        }
    }
    
    func test_인터넷_연결에_실패한_경우() {
        MockURLProtocol.responseWithFailure(error: .noInternetConnection)
        
        let result = fetchStoresRepository.fetchStores(requestLocation: mockRequestLocation).toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTFail("Error 방출 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? ErrorAlertMessage, ErrorAlertMessage.internet)
        }
    }
    
    func test_서버_연결에_실패한_경우() {
        MockURLProtocol.responseWithFailure(error: .noServerConnection)
        
        let result = fetchStoresRepository.fetchStores(requestLocation: mockRequestLocation).toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTFail("Error 방출 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? ErrorAlertMessage, ErrorAlertMessage.server)
        }
    }
    
    func test_Day_toEntity_실패한_경우() {
        MockURLProtocol.responseWithStatusCode(code: 200)
        MockURLProtocol.setResponseFile(type: .fetchStoresFailureWithWrongDay)
        
        let result = fetchStoresRepository.fetchStores(requestLocation: mockRequestLocation).toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTFail("Error 방출 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? JSONContentsError, JSONContentsError.wrongDay)
        }
    }
    
    func test_Certification_toEntity_실패한_경우() {
        MockURLProtocol.responseWithStatusCode(code: 200)
        MockURLProtocol.setResponseFile(type: .fetchStoresFailureWithWrongCeritifcation)
        
        let result = fetchStoresRepository.fetchStores(requestLocation: mockRequestLocation).toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTFail("Error 방출 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? JSONContentsError, JSONContentsError.wrongCertificationType)
        }
    }
    
    func test_Alamofire_통신에_실패한_경우() {
        MockURLProtocol.responseWithFailure(error: .alamofireError)
        
        let result = fetchStoresRepository.fetchStores(requestLocation: mockRequestLocation).toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTFail("Error 방출 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? ErrorAlertMessage, ErrorAlertMessage.client)
        }
    }
    
}