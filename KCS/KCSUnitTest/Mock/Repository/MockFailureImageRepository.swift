//
//  MockFailureImageRepository.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/25/24.
//

import Foundation
@testable import KCS
import RxSwift
import Alamofire

struct MockNoImageFailureImageRepository: FetchImageRepository {
    
    var cache: ImageCache
    var session: Session = Session.default
    
    func fetchImage(url: String) -> Observable<Data> {
        return Observable.create { observer -> Disposable in
            observer.onError(ImageRepositoryError.noImageData)
            
            return Disposables.create()
        }
    }
    
}

struct MockAPIFailureImageRepository: FetchImageRepository {
    
    var cache: ImageCache
    var session: Session = Session.default
    
    func fetchImage(url: String) -> Observable<Data> {
        return Observable.create { observer -> Disposable in
            observer.onError(ErrorAlertMessage.server)
            
            return Disposables.create()
        }
    }
    
}
