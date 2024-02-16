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
    case getSearchStores(searchDTO: SearchDTO)
    
}

extension StoreAPI: Router, URLRequestConvertible {
    
    var baseURL: String? {
        switch self {
        case .getStores, .getSearchStores:
            return getURL(type: .product)
        case .getImage(let url):
            return url
        }
    }
    
    var path: String {
        switch self {
        case .getStores:
            return "/byLocation/v2"
        case .getImage:
            return ""
        case .getSearchStores:
            return "/byLocationAndKeyword/v1"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getStores, .getImage, .getSearchStores:
            return .get
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .getStores, .getSearchStores:
            return [
                "Content-Type": "application/json"
            ]
        case .getImage:
            return [:]
        }
    }
    
    var parameters: [String: Any]? {
        do {
            switch self {
            case let .getStores(location):
                return try location.asDictionary()
            case .getImage:
                return [:]
            case let .getSearchStores(searchDTO):
                return try searchDTO.asDictionary()
            }
        } catch {
            return nil
        }
    }
    
    /// 파라미터로 보내야할 것이 있다면, URLEncoding.default
    /// 바디에 담아서 보내야할 것이 있다면, JSONEncoding.default
    var encoding: ParameterEncoding? {
        switch self {
        case .getStores, .getSearchStores:
            return URLEncoding.default
        case .getImage:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let base = baseURL,
              let url = URL(string: base + path) else {
            throw NetworkError.wrongURL
        }
        var request = URLRequest(url: url)
        
        request.method = method
        request.headers = HTTPHeaders(headers)
        
        if let encoding = encoding {
            if let parameters = parameters {
                return try encoding.encode(request, with: parameters)
            } else {
                throw NetworkError.wrongParameters
            }
        }
        
        return request
    }
    
}

private extension StoreAPI {
    
    enum URLType {
        
        case develop
        case product
        
    }
    
    func getURL(type: URLType) -> String? {
        switch type {
        case .develop:
            guard let url = Bundle.main.object(forInfoDictionaryKey: "DEV_SERVER_URL") as? String else { return nil }
            return url
        case .product:
            guard let url = Bundle.main.object(forInfoDictionaryKey: "PROD_SERVER_URL") as? String else { return nil }
            return url
        }
    }
    
}
