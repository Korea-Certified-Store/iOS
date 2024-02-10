//
//  GetStoreInformationUseCaseImpl.swift
//  KCS
//
//  Created by 김영현 on 1/17/24.
//

import Foundation

struct GetStoreInformationUseCaseImpl: GetStoreInformationUseCase {
    
    let repository: GetStoresRepository
    
    func execute(tag: UInt) throws -> Store {
        let stores = repository.getStores()
        guard let store = stores.first(where: { $0.id == tag }) else { throw StoreRepositoryError.wrongStoreId }
        return store
    }
    
}
