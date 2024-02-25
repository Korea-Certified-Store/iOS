//
//  MockServer.swift
//  KCSUnitTest
//
//  Created by 조성민 on 2/25/24.
//

import RxSwift
import Alamofire
@testable import KCS

enum MockAPIType {
    
    case example
    
}

final class MockServer: Router {
    
    typealias API = MockAPIType
    
    var type: API
    
    var baseURL: String?
    
    var path: String = ""
    
    var method: HTTPMethod = .get
    
    var headers: [String: String] = [:]
    
    var parameters: [String: Any]?
    
    var encoding: ParameterEncoding?
    
    init(type: API) {
        self.type = type
    }
    
    func execute<T>(requestValue: T) throws where T: Encodable { }
    
    func asURLRequest() throws -> URLRequest {
        let request = URLRequest(
        switch type {
        case .example:
            return
        }
    }
    
}
