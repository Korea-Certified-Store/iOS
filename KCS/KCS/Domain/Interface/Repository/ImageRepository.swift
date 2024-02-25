//
//  ImageRepository.swift
//  KCS
//
//  Created by 조성민 on 1/19/24.
//

import RxSwift
import Alamofire

protocol ImageRepository {
    
    var cache: ImageCache { get }
    var storeAPI: any Router { get }
    var session: NetworkSession { get }
    
    func fetchImage(
        url: String
    ) -> Observable<Data>
    
}
