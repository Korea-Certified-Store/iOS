//
//  NetworkSession.swift
//  KCS
//
//  Created by 조성민 on 2/25/24.
//

import Foundation
import Alamofire

protocol NetworkSession {
    
    @discardableResult
    func request(
        _ convertible: URLRequestConvertible
    ) -> DataRequest
    
}

final class AlamofireSession: NetworkSession {
    
    func request(_ convertible: URLRequestConvertible) -> DataRequest {
        return AF.request(convertible)
    }
    
}
