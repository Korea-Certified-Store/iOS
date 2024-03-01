//
//  FakeUserDefaults.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/29/24.
//

import Foundation

final class FakeUserDefaults: UserDefaults {
    
    convenience init() {
        self.init(suiteName: "FakeUserDefaults")!
    }
    
    override init?(suiteName suitename: String?) {
        UserDefaults().removePersistentDomain(forName: suitename!)
        super.init(suiteName: suitename)
    }
    
}
