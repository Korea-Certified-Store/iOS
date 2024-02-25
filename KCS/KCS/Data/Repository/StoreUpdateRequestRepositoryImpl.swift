//
//  StoreUpdateRequestRepositoryImpl.swift
//  KCS
//
//  Created by 조성민 on 2/18/24.
//

import RxSwift
import Alamofire

final class StoreUpdateRequestRepositoryImpl: StoreUpdateRequestRepository {
    
    let storeAPI: any Router
    let session: NetworkSession
    
    init(storeAPI: any Router, session: NetworkSession) {
        self.storeAPI = storeAPI
        self.session = session
    }
    
    func storeUpdateReqeust(type: StoreUpdateRequestType, storeID: Int, content: String) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer -> Disposable in
            do {
                guard let self = self else { return Disposables.create() }
                try storeAPI.execute(
                    requestValue: UpdateRequestDTO(
                        dtype: type.rawValue,
                        storeId: storeID,
                        contents: content
                    )
                )
                session.request(storeAPI)
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
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
}
