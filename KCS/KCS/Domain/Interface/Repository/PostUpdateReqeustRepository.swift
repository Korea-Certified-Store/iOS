//
//  PostUpdateReqeustRepository.swift
//  KCS
//
//  Created by 조성민 on 2/18/24.
//

import RxSwift

protocol PostUpdateReqeustRepository {
    
    func PostUpdateReqeust(
        updateReqeustDTO: UpdateRequestDTO
    ) -> Observable<Void>
    
}

