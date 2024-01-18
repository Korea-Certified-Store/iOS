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
                        .responseDecodable(of: Data.self) { response in
                            switch response.result {
                            case .success(let result):
                                ImageCache.shared.setImageData(result as NSData, for: imageURL as NSURL)
                                observer.onNext(result)
                            case .failure(let error):
                                observer.onError(error)
                            }
                        }
                }
            }
            
            return Disposables.create()
        }
    }
    
}
