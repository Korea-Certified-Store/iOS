//
//  MockURLProtocol.swift
//  KCSUnitTest
//
//  Created by 조성민 on 2/25/24.
//

import Foundation
import Alamofire
@testable import KCS

final class MockURLProtocol: URLProtocol {
    
    enum ResponseType {
        
        case error(Error)
        case success(HTTPURLResponse)
        
    }
    
    static var responseType: ResponseType?
    static var jsonFile: MockJSONFile?
    
    private lazy var session: URLSession = {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        
        return URLSession(configuration: configuration)
    }()
    
    private(set) var activeTask: URLSessionTask?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    override func startLoading() {
        let response = setUpMockResponse()
        let data = setUpMockData()
        
        if let response = response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data!)
        }
        self.client?.urlProtocolDidFinishLoading(self)
        activeTask = session.dataTask(with: request.urlRequest!)
        activeTask?.cancel()
    }
    
    private func setUpMockResponse() -> HTTPURLResponse? {
        var response: HTTPURLResponse?
        switch MockURLProtocol.responseType {
        case .error(let error)?:
            dump(error)
            client?.urlProtocol(self, didFailWithError: error)
        case .success(let newResponse)?:
            response = newResponse
        default:
            fatalError("No fake responses found.")
        }
        
        return response
    }
    
    private func setUpMockData() -> Data? {
        guard let fileName: String = MockURLProtocol.jsonFile?.fileName,
              let file = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        return try? Data(contentsOf: file)
    }
    
    override func stopLoading() {
        activeTask?.cancel()
    }
    
}

extension MockURLProtocol {
    
    enum MockError: Error {
        case noInternetConnection
        case noServerConnection
        case alamofireError
    }
    
    static func responseWithFailure(error: MockError) {
        let responseError: Error = {
            switch error {
            case .noInternetConnection:
                NSError(
                    domain: "",
                    code: URLError.notConnectedToInternet.rawValue
                )
            case .noServerConnection:
                AFError.sessionTaskFailed(error: MockError.noServerConnection)
            case .alamofireError:
                AFError.explicitlyCancelled
            }
        }()
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.error(responseError)
    }
    
    static func responseWithStatusCode(code: Int) {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "DEV_SERVER_URL") as? String else {
            return
        }
        guard let url = URL(string: urlString),
              let httpResponse = HTTPURLResponse(
                url: url,
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
              ) else { return }
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.success(httpResponse)
    }
    
    static func setResponseFile(type: MockJSONFile) {
        MockURLProtocol.jsonFile = type
    }
    
}

extension MockURLProtocol {
    
    enum MockJSONFile {
        
        case fetchStoresSuccessWithZeroStore
        case fetchStoresSuccessWithManyStores
        case fetchStoresFailureWithWrongDay
        case fetchStoresFailureWithWrongCeritifcation
        
        var fileName: String {
            switch self {
            case .fetchStoresSuccessWithZeroStore:
                return "FetchStoresSuccessWithZeroStore"
            case .fetchStoresSuccessWithManyStores:
                return "FetchStoresSuccessWithManyStores"
            case .fetchStoresFailureWithWrongDay:
                return "FetchStoresFailureWithWrongDay"
            case .fetchStoresFailureWithWrongCeritifcation:
                return "FetchStoresFailureWithWrongCeritifcation"
            }
        }
        
    }
    
}
