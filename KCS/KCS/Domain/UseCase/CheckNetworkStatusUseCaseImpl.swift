//
//  CheckNetworkStatusUseCaseImpl.swift
//  KCS
//
//  Created by 김영현 on 2/8/24.
//

import Foundation

struct CheckNetworkStatusUseCaseImpl: CheckNetworkStatusUseCase {
    
    let repository: NetworkRepository
    
    func execute() -> Bool {
        return repository.checkDeviceNetworkStatus()
    }
    
}
