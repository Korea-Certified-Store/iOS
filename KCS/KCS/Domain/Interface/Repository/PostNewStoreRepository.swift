//
//  PostNewStoreRepository.swift
//  KCS
//
//  Created by 김영현 on 2/19/24.
//

import RxSwift
import Alamofire

protocol PostNewStoreRepository {
    
    var session: Session { get }
    
    func postNewStore(
        storeName: String,
        formattedAddress: String,
        certifications: [CertificationType]
    ) -> Observable<Void>
    
}
