//
//  StoreUpdateRequestRepository.swift
//  KCS
//
//  Created by 조성민 on 2/18/24.
//

import RxSwift
import Alamofire

protocol StoreUpdateRequestRepository {
    
    var storeAPI: any Router { get }
    var session: Session { get }
    
    func storeUpdateReqeust(
        type: StoreUpdateRequestType,
        storeID: Int,
        content: String
    ) -> Observable<Void>
    
}
