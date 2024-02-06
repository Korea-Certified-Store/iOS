//
//  Storage.swift
//  KCS
//
//  Created by 김영현 on 2/5/24.
//

import Foundation

final class Storage {
    
    static func isOnboarded() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "executeOnboarding") == nil {
            return true
        } else {
            return false
        }
    }
    
}
