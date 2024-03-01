//
//  PostNewStoreRepositoryImplTests.swift
//  KCSUnitTest
//
//  Created by 김영현 on 3/1/24.
//

import XCTest
@testable import KCS
import RxSwift
import RxBlocking
import Alamofire

struct PostNewStoreRepositoryImplTestsConstant {
    
    let storeName = "테스트 가게"
    let formattedAddress = "테스트 주소"
    let certifications: [CertificationType] = [.goodPrice, .safe]
    
}

final class PostNewStoreRepositoryImplTests: XCTestCase {
    
    private var postNewStoreRepository: PostNewStoreRepositoryImpl!
    private var session: Session!
    private var constant: PostNewStoreRepositoryImplTestsConstant!

    override func setUp() {
        constant = PostNewStoreRepositoryImplTestsConstant()
        session = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [MockURLProtocol.self]
                return configuration
            }()
            return Session(configuration: configuration)
        }()
        postNewStoreRepository = PostNewStoreRepositoryImpl(session: session)
    }
    
    func test_새로운_가게_추가를_하는_경우() {
        // Given
        MockURLProtocol.responseWithStatusCode(code: 200)
        
        // When
        do {
            let result: Void? = try postNewStoreRepository.postNewStore(
                storeName: constant.storeName,
                formattedAddress: constant.formattedAddress,
                certifications: constant.certifications
            ).toBlocking().first()
            
            // Then
            XCTAssertNotNil(result)
        } catch {
            XCTFail("새로운 가게 추가 실패")
        }
    }
    
    func test_인터넷_연결에_실패한_경우() {
        // Given
        MockURLProtocol.responseWithFailure(error: .noInternetConnection)
        
        // When
        let result = postNewStoreRepository.postNewStore(
            storeName: constant.storeName,
            formattedAddress: constant.formattedAddress,
            certifications: constant.certifications
        ).toBlocking().materialize()
        
        // Then
        switch result {
        case .completed:
            XCTFail("Error 방출 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? ErrorAlertMessage, ErrorAlertMessage.internet)
        }
    }
    
    func test_서버_연결에_실패한_경우() {
        // Given
        MockURLProtocol.responseWithFailure(error: .noServerConnection)
        
        // When
        let result = postNewStoreRepository.postNewStore(
            storeName: constant.storeName,
            formattedAddress: constant.formattedAddress,
            certifications: constant.certifications
        ).toBlocking().materialize()
        
        // Then
        switch result {
        case .completed:
            XCTFail("Error 방출 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? ErrorAlertMessage, ErrorAlertMessage.server)
        }
    }
    
    func test_Alamofire_통신에_실패한_경우() {
        // Given
        MockURLProtocol.responseWithFailure(error: .alamofireError)
        
        // When
        let result = postNewStoreRepository.postNewStore(
            storeName: constant.storeName,
            formattedAddress: constant.formattedAddress,
            certifications: constant.certifications
        ).toBlocking().materialize()
        
        // Then
        switch result {
        case .completed:
            XCTFail("Error 방출 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? ErrorAlertMessage, ErrorAlertMessage.client)
        }
    }

}
