//
//  StoreUpdateRequestRepositoryImpl.swift
//  KCS
//
//  Created by 조성민 on 2/18/24.
//

import RxSwift
import Alamofire

final class StoreUpdateRequestRepositoryImpl: StoreUpdateRequestRepository {
    
    let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func storeUpdateReqeust(type: StoreUpdateRequestType, storeID: Int, content: String) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer -> Disposable in
            self?.session.request(StoreAPI.storeUpdateRequest(
                updateRequestDTO:
                    UpdateRequestDTO(
                        dtype: type.rawValue,
                        storeId: storeID,
                        contents: content
                    )
            ))
            .response { response in
                switch response.result {
                case .success:
                    observer.onNext(())
                case .failure(let error):
                    if let underlyingError = error.underlyingError as? NSError,
                       underlyingError.code == URLError.notConnectedToInternet.rawValue {
                        observer.onError(ErrorAlertMessage.internet)
                    } else if let underlyingError = error.underlyingError as? NSError,
                              underlyingError.code == 13 {
                        observer.onError(ErrorAlertMessage.server)
                    } else {
                        observer.onError(ErrorAlertMessage.client)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
}
