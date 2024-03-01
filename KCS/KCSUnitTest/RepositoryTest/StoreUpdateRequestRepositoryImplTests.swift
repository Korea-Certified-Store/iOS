//
//  StoreUpdateRequestRepositoryImplTests.swift
//  KCSUnitTest
//
//  Created by 조성민 on 3/1/24.
//

import XCTest
@testable import KCS
import RxSwift
import Alamofire

struct StoreUpdateRequestRepositoryImplTestsConstant {
    
    let fixType: StoreUpdateRequestType = .fix
    let deleteType: StoreUpdateRequestType = .delete
    let storeID: Int = 1
    let content: String = "content"
    
}

final class StoreUpdateRequestRepositoryImplTests: XCTestCase {

    private var storeUpdateRequestRepository: StoreUpdateRequestRepositoryImpl!
    private var constant: StoreUpdateRequestRepositoryImplTestsConstant!
    
    override func setUp() {
        let session: Session = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [MockURLProtocol.self]
                return configuration
            }()
            return Session(configuration: configuration)
        }()
        
        storeUpdateRequestRepository = StoreUpdateRequestRepositoryImpl(session: session)
        constant = StoreUpdateRequestRepositoryImplTestsConstant()
    }

    func test_수정_업데이트_요청_성공한_경우() {
        // Given
        MockURLProtocol.responseWithStatusCode(code: 200)
        
        do {
            // When
            let result: Void? = try storeUpdateRequestRepository.storeUpdateReqeust(
                type: constant.fixType,
                storeID: constant.storeID,
                content: constant.content
            ).toBlocking().first()
            
            // Then
            XCTAssertNotNil(result)
        } catch {
            XCTFail("수정 요청 실패")
        }
    }
    
    func test_삭제_업데이트_요청_성공한_경우() {
        // Given
        MockURLProtocol.responseWithStatusCode(code: 200)
        
        do {
            // When
            let result: Void? = try storeUpdateRequestRepository.storeUpdateReqeust(
                type: constant.deleteType,
                storeID: constant.storeID,
                content: constant.content
            ).toBlocking().first()
            
            // Then
            XCTAssertNotNil(result)
        } catch {
            XCTFail("수정 요청 실패")
        }
    }

    func test_인터넷_연결에_실패한_경우() {
        // Given
        MockURLProtocol.responseWithFailure(error: .noInternetConnection)
        
        // When
        let result = storeUpdateRequestRepository.storeUpdateReqeust(
            type: constant.fixType,
            storeID: constant.storeID,
            content: constant.content
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
        let result = storeUpdateRequestRepository.storeUpdateReqeust(
            type: constant.fixType,
            storeID: constant.storeID,
            content: constant.content
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
        let result = storeUpdateRequestRepository.storeUpdateReqeust(
            type: constant.fixType,
            storeID: constant.storeID,
            content: constant.content
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
