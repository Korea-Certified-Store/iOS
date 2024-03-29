//
//  FetchImageRepository.swift
//  KCS
//
//  Created by 조성민 on 1/19/24.
//

import RxSwift
import Alamofire

protocol FetchImageRepository {
    
    var cache: ImageCache { get }
    var session: Session { get }
    
    func fetchImage(
        url: String
    ) -> Observable<Data>
    
}
