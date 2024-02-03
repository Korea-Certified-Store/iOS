//
//  Encodable+.swift
//  KCS
//
//  Created by 조성민 on 1/12/24.
//

import Foundation

extension Encodable {
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(
            with: data,
            options: .allowFragments
        ) as? [String: Any] else {
            throw JSONContentsError.dictionaryConvert
        }
        return dictionary
    }
    
}
