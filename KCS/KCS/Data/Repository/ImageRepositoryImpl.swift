//
//  ImageRepositoryImpl.swift
//  KCS
//
//  Created by 조성민 on 1/19/24.
//

import RxSwift
import Alamofire

final class ImageRepositoryImpl: ImageRepository {
    
    func fetchImage(
        url: String
    ) -> Observable<Data> {
        return Observable<Data>.create { observer -> Disposable in
            if let imageURL = URL(string: url) {
                if let imageData = ImageCache.shared.getImageData(for: imageURL as NSURL) {
                    observer.onNext(Data(imageData))
                } else {
                    AF.request(StoreAPI.getImage(url: url))
                        .response(completionHandler: { response in
                            switch response.result {
                            case .success(let result):
                                if let resultData = result {
                                    ImageCache.shared.setImageData(resultData as NSData, for: imageURL as NSURL)
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
