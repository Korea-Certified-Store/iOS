//
//  MockSuccessImageRepository.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/25/24.
//

import Foundation
@testable import KCS
import Alamofire
import RxSwift

struct MockSuccessImageRepository: ImageRepository {
    
    var cache: ImageCache
    var session: Session = Session.default
    
    func fetchImage(url: String) -> Observable<Data> {
        return Observable.create { observer -> Disposable in
            if let url = URL(string: url) {
                if let imageData = cache.getImageData(for: url as NSURL) {
                    observer.onNext(Data(imageData))
                } else {
                    guard let data = "no_cache".data(using: .utf8) else { return Disposables.create() }
                    observer.onNext(data)
                }
            }
            return Disposables.create()
        }
    }
    
}
