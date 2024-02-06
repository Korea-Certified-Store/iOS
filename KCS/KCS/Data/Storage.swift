//
//  Storage.swift
//  KCS
//
//  Created by 김영현 on 2/5/24.
//

import Foundation

final class Storage {
    
    static func executeOnBoarding() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "executeOnBoarding") == nil {
            return true
        } else {
            return false
        }
    }
    
}
