//
//  MockSuccessNetworkRepository.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/25/24.
//

import Foundation
@testable import KCS

struct MockSuccessNetworkRepository: NetworkRepository {
    
    func checkDeviceNetworkStatus() -> Bool {
        return true
    }
    
}
