//
//  MockFailureImageRepository.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/25/24.
//

import Foundation
@testable import KCS
import RxSwift

struct MockNoImageFailureImageRepository: ImageRepository {
    
    var cache: ImageCache
    var storeAPI: Router
    
    func fetchImage(url: String) -> Observable<Data> {
        return Observable.create { observer -> Disposable in
            observer.onError(ImageRepositoryError.noImageData)
            
            return Disposables.create()
        }
    }
    
}

struct MockAPIFailureImageRepository: ImageRepository {
    
    var cache: ImageCache
    var storeAPI: Router
    
    func fetchImage(url: String) -> Observable<Data> {
        return Observable.create { observer -> Disposable in
            observer.onError(ErrorAlertMessage.server)
            
            return Disposables.create()
        }
    }
    
}
