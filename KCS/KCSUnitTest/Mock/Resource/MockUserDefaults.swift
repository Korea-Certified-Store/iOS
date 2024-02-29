//
//  MockUserDefaults.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/29/24.
//

import Foundation

final class MockUserDefaults: UserDefaults {
    
    convenience init() {
        self.init(suiteName: "MockUserDefaults")!
    }
    
    override init?(suiteName suitename: String?) {
        UserDefaults().removePersistentDomain(forName: suitename!)
        super.init(suiteName: suitename)
    }
    
}
