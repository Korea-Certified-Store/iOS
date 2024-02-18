//
//  PostUpdateRequestRepositoryImpl.swift
//  KCS
//
//  Created by 조성민 on 2/18/24.
//

import RxSwift
import Alamofire

final class PostUpdateRequestRepositoryImpl: PostUpdateRequestRepository {
    
    func postUpdateReqeust(type: String, storeID: Int, content: String) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            AF.request(StoreAPI.postUpdateRequest(
                updateRequestDTO:
                    UpdateRequestDTO(
                        dtype: type,
                        storeId: storeID,
                        contents: content
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
