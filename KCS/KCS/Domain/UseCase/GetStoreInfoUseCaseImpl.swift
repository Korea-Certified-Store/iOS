//
//  GetStoreInfoUseCaseImpl.swift
//  KCS
//
//  Created by 김영현 on 1/17/24.
//

import Foundation

struct GetStoreInfoUseCaseImpl: GetStoreInfoUseCase {
    
    let repository: StoreRepository
    
    func execute(tag: UInt) -> Store? {
        do {
            return try repository.getStoreInfo(tag: tag)
        } catch {
            dump(error)
        }
        return nil
    }
    
}
