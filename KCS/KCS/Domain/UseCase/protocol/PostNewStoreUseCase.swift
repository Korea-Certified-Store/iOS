//
//  PostNewStoreUseCase.swift
//  KCS
//
//  Created by 김영현 on 2/19/24.
//

import RxSwift

protocol PostNewStoreUseCase {
    
    var repository: PostNewStoreRepository { get }
    
    init(repository: PostNewStoreRepository)
    
    func execute(storeName: String, formattedAddress: String, certifications: [CertificationType]) -> Observable<Void>
    
}
