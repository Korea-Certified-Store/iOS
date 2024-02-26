//
//  PostNewStoreRepositoryImpl.swift
//  KCS
//
//  Created by 김영현 on 2/19/24.
//

import RxSwift
import Alamofire

final class PostNewStoreRepositoryImpl: PostNewStoreRepository {
    
    let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func postNewStore(storeName: String, formattedAddress: String, certifications: [CertificationType]) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer -> Disposable in
            self?.session.request(StoreAPI.postNewStoreRequest(
                newStoreRequestDTO: NewStoreRequestDTO(
                    storeName: storeName,
                    formattedAddress: formattedAddress,
                    certifications: certifications.map { $0.rawValue }
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
                    } else {
                        observer.onError(ErrorAlertMessage.client)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
}
