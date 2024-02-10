//
//  GetStoreInformationUseCaseImpl.swift
//  KCS
//
//  Created by 김영현 on 1/17/24.
//

import Foundation

struct GetStoreInformationUseCaseImpl: GetStoreInformationUseCase {
    
    let repository: GetStoreInformationRepository
    
    func execute(tag: UInt) throws -> Store {
        return try repository.getStoreInformation(tag: tag)
    }
    
}
