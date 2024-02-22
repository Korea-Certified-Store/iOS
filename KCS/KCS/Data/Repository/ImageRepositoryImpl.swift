//
//  ImageRepositoryImpl.swift
//  KCS
//
//  Created by 조성민 on 1/19/24.
//

import RxSwift
import Alamofire

struct ImageRepositoryImpl: ImageRepository {
    
    let cache: ImageCache
    
    func fetchImage(
        url: String
    ) -> Observable<Data> {
        return Observable<Data>.create { observer -> Disposable in
            if let imageURL = URL(string: url) {
                if let imageData = cache.getImageData(for: imageURL as NSURL) {
                    observer.onNext(Data(imageData))
                } else {
                    AF.request(StoreAPI.getImage(url: url))
                        .response(completionHandler: { response in
                            switch response.result {
                            case .success(let result):
                                if let resultData = result, String(data: resultData, encoding: .utf8) == nil {
                                    cache.setImageData(resultData as NSData, for: imageURL as NSURL)
                                    observer.onNext(resultData)
                                } else {
                                    observer.onError(ImageRepositoryError.noImageData)
                                }
                            case .failure(let error):
                                observer.onError(error)
                            }
                        })
                }
            }
            
            return Disposables.create()
        }
    }
    
}
