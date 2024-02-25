//
//  Router.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import Alamofire

protocol Router {
    
    associatedtype RequestValue
    
    var type: APIType { get }
    var baseURL: String? { get set }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var parameters: [String: Any]? { get set }
    var encoding: ParameterEncoding? { get }
    
    func execute(requestValue: RequestValue) throws -> URLRequest
    
}
