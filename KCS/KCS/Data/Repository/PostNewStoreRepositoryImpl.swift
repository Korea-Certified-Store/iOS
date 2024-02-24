//
//  PostNewStoreRepositoryImpl.swift
//  KCS
//
//  Created by 김영현 on 2/19/24.
//

import RxSwift
import Alamofire

final class PostNewStoreRepositoryImpl: PostNewStoreRepository {
    
    let storeAPI: StoreAPI<NewStoreRequestDTO>
    
    init(storeAPI: StoreAPI<NewStoreRequestDTO>) {
        self.storeAPI = storeAPI
    }
    
    func postNewStore(storeName: String, formattedAddress: String, certifications: [CertificationType]) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let urlRequest = storeAPI.execute(
                    requestValue: NewStoreRequestDTO(
                        storeName: storeName,
                        formattedAddress: formattedAddress,
                        certifications: certifications.map { $0.rawValue }
                    )
                  ) else { return Disposables.create() }
            AF.request(urlRequest)
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
