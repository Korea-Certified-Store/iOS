//
//  FetchAutoCompletionRepositoryImplTests.swift
//  KCSUnitTest
//
//  Created by 김영현 on 3/1/24.
//

import XCTest
@testable import KCS
import Alamofire
import RxSwift
import RxBlocking

final class FetchAutoCompletionRepositoryImplTestsConstant {
    
    let searchKeyword = "커피"
    let searchKeywordWithZeroAutoCompletion = "asdf"
    let resultAutoCompletionWithZeroAutoCompletion: [String] = []
    var resultAutoCompletion: [String] = []
    
    init() {
        self.convertToDTO()
    }
    
    func convertToDTO() {
        guard let path = Bundle(for: type(of: self)).url(forResource: "FetchAutoCompletionSuccess", withExtension: "json") else {
            return
        }
        guard let jsonString = try? String(contentsOf: path) else {
            return
        }
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        if let data = data,
           let response = try? decoder.decode(AutoCompletionResponse.self, from: data) {
            resultAutoCompletion = response.data
        } else {
            return
        }
    }
    
}

final class FetchAutoCompletionRepositoryImplTests: XCTestCase {
    
    private var fetchAutoCompletionRepository: FetchAutoCompletionRepository!
    private var session: Session!
    private var constant: FetchAutoCompletionRepositoryImplTestsConstant!

    override func setUp() {
        session = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [MockURLProtocol.self]
                return configuration
            }()
            return Session(configuration: configuration)
        }()
        fetchAutoCompletionRepository = FetchAutoCompletionRepositoryImpl(
            session: session
        )
        constant = FetchAutoCompletionRepositoryImplTestsConstant()
    }

    func test_커피에_대한_자동완성_API요청을_한_경우() {
        // Given
        MockURLProtocol.responseWithStatusCode(code: 200)
        MockURLProtocol.setResponseFile(type: .fetchAutoCompletionSuccess)
        
        // When
        do {
            let result = try fetchAutoCompletionRepository.fetchAutoCompletion(searchKeyword: constant.searchKeyword).toBlocking().first()
            
            // Then
            XCTAssertEqual(result, constant.resultAutoCompletion)
        } catch {
            XCTFail("자동완성 API 요청 실패")
        }
    }
    
    func test_asdf에_대한_자동완성_API요청을_한_경우() {
        // Given
        MockURLProtocol.responseWithStatusCode(code: 200)
        MockURLProtocol.setResponseFile(type: .fetchAutoCompletionSuccessWithZeroAutoCompletion)
        
        // When
        do {
            let result = try fetchAutoCompletionRepository.fetchAutoCompletion(searchKeyword: constant.searchKeywordWithZeroAutoCompletion).toBlocking().first()
            
            // Then
            XCTAssertEqual(result, constant.resultAutoCompletionWithZeroAutoCompletion)
        } catch {
            XCTFail("결과가 없는 자동완성 API 요청 실패")
        }
    }
    
    func test_인터넷_연결에_실패한_경우() {
        // Given
        MockURLProtocol.responseWithFailure(error: .noInternetConnection)
        
        // When
        let result = fetchAutoCompletionRepository.fetchAutoCompletion(searchKeyword: constant.searchKeyword).toBlocking().materialize()
        
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
        let result = fetchAutoCompletionRepository.fetchAutoCompletion(searchKeyword: constant.searchKeyword).toBlocking().materialize()
        
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
        let result = fetchAutoCompletionRepository.fetchAutoCompletion(searchKeyword: constant.searchKeyword).toBlocking().materialize()
        
        // Then
        switch result {
        case .completed:
            XCTFail("Error 방출 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? ErrorAlertMessage, ErrorAlertMessage.client)
        }
    }
    
}
