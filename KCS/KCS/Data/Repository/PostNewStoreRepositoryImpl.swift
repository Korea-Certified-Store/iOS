//
//  PostNewStoreRepositoryImpl.swift
//  KCS
//
//  Created by 김영현 on 2/19/24.
//

import RxSwift
import Alamofire

final class PostNewStoreRepositoryImpl: PostNewStoreRepository {
    
    func postNewStore(storeName: String, formattedAddress: String, certifications: [CertificationType]) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            AF.request(StoreAPI.postNewStore(
                newStoreRequestDTO: NewStoreRequestDTO(
                    storeName: storeName,
                    formattedAddress: formattedAddress,
                    certifications: certifications.map{ $0.rawValue }
                )
            ))
            .response { response in
                switch response.result {
                case .success:
                    observer.onNext(())
                case .failure(let error):
                    if let underlyingError = error.underlyingError as? NSError {
                        switch underlyingError.code {
                        case URLError.notConnectedToInternet.rawValue:
                            observer.onError(ErrorAlertMessage.internet)
                        default:
                            observer.onError(ErrorAlertMessage.server)
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }
    
}
