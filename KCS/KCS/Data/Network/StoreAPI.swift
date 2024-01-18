//
//  StoreAPI.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import RxSwift
import Alamofire

enum StoreAPI {
    
    case getStores(location: RequestLocationDTO)
    case getImage(url: String)
    
}

extension StoreAPI: Router, URLRequestConvertible {

    public var baseURL: String {
        switch self {
        case .getStores:
            return NetworkURL.storeURL
        case .getImage(let url):
            return url
        }
    }
    
    public var path: String {
        switch self {
        case .getStores, .getImage:
            return ""
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getStores, .getImage:
            return .get
        }
    }
    
    public var headers: [String: String] {
        switch self {
        case .getStores, .getImage:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    
    public var parameters: [String: Any]? {
        do {
            switch self {
            case let .getStores(location):
                return try location.asDictionary()
            case .getImage:
                return nil
            }
        } catch let error {
            dump(error)
            return nil
        }
    }
    
    /// 파라미터로 보내야할 것이 있다면, URLEncoding.default
    /// 바디에 담아서 보내야할 것이 있다면, JSONEncoding.default
    public var encoding: ParameterEncoding? {
        switch self {
        case .getStores:
            return URLEncoding.default
        case .getImage:
            return nil
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw NetworkError.wrongURL
        }
        var request = URLRequest(url: url)
        
        request.method = method
        request.headers = HTTPHeaders(headers)
        
        if let encoding = encoding {
            return try encoding.encode(request, with: parameters)
        }
        
        return request
    }
    
}
