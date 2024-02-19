//
//  PostNewStoreUseCaseImpl.swift
//  KCS
//
//  Created by 김영현 on 2/19/24.
//

import RxSwift

struct PostNewStoreUseCaseImpl: PostNewStoreUseCase {
    
    let repository: PostNewStoreRepository
    
    func execute(
        storeName: String,
        formattedAddress: String,
        certifications: [CertificationType]
    ) -> Observable<Void> {
        return repository.postNewStore(storeName: storeName, formattedAddress: formattedAddress, certifications: certifications)
    }
    
}
