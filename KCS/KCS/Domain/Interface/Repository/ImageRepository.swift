//
//  ImageRepository.swift
//  KCS
//
//  Created by 조성민 on 1/19/24.
//

import RxSwift

protocol ImageRepository {
    
    func fetchImage(
        url: String
    ) -> Observable<Data>
    
}
