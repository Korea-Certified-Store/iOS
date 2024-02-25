//
//  ImageRepository.swift
//  KCS
//
//  Created by 조성민 on 1/19/24.
//

import RxSwift

protocol ImageRepository {
    
    var cache: ImageCache { get }
    var storeAPI: Router { get }
    
    func fetchImage(
        url: String
    ) -> Observable<Data>
    
}
