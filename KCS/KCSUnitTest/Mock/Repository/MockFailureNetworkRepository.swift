//
//  MockFailureNetworkRepository.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/25/24.
//

import Foundation
@testable import KCS

struct MockFailureNetworkRepository: NetworkRepository {
    
    func checkDeviceNetworkStatus() -> Bool {
        return false
    }
    
}
