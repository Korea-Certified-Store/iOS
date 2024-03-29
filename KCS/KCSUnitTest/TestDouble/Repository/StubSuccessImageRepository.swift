//
//  StubSuccessImageRepository.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/25/24.
//

import Foundation
@testable import KCS
import Alamofire
import RxSwift

final class StubSuccessImageRepository: FetchImageRepository {
    
    var cache: ImageCache
    var session: Session = Session.default
    let mockImage = MockImage()
    
    init(cache: ImageCache) {
        self.cache = cache
    }
    
    func fetchImage(url: String) -> Observable<Data> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            if let url = URL(string: url) {
                if let imageData = cache.getImageData(for: url as NSURL) {
                    observer.onNext(Data(imageData))
                } else {
                    observer.onNext(mockImage.getImageURL())
                }
            }
            return Disposables.create()
        }
    }
    
}
