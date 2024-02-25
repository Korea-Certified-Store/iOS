//
//  PostNewStoreRepository.swift
//  KCS
//
//  Created by 김영현 on 2/19/24.
//

import RxSwift

protocol PostNewStoreRepository {
    
    var storeAPI: Router { get }
    
    func postNewStore(
        storeName: String,
        formattedAddress: String,
        certifications: [CertificationType]
    ) -> Observable<Void>
    
}
