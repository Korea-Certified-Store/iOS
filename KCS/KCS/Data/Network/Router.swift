//
//  Router.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import Alamofire

protocol Router {
    
    var baseURL: String? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var parameters: [String: Any]? { get }
    var encoding: ParameterEncoding? { get }
    
}
