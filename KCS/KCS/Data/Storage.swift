//
//  Storage.swift
//  KCS
//
//  Created by 김영현 on 2/5/24.
//

import Foundation

final class Storage {
    
    static func isFirstTime() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirstTime") == nil {
            defaults.set(false, forKey: "isFirstTime")
            return true
        } else {
            return false
        }
    }
    
}
