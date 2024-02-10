//
//  GetStoreInformationRepositoryImpl.swift
//  KCS
//
//  Created by 김영현 on 2/11/24.
//

import Foundation

final class GetStoreInformationRepositoryImpl: GetStoreInformationRepository {
    
    let storeStorage: StoreStorage
    
    init(storeStorage: StoreStorage) {
        self.storeStorage = storeStorage
    }
    
    func getStoreInformation(
        tag: UInt
    ) throws -> Store {
        guard let store = storeStorage.stores.first(where: { $0.id == tag }) else { throw StoreRepositoryError.wrongStoreId }
        return store
    }
    
}
