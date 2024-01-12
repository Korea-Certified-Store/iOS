//
//  APIResponse.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import Foundation

protocol APIResponse: Codable {
    
    associatedtype ResponseType
    
    var code: Int { get }
    var message: String { get }
    var data: [ResponseType] { get }
    
}
