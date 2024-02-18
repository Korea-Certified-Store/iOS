//
//  PostUpdateReqeustRepositoryImpl.swift
//  KCS
//
//  Created by 조성민 on 2/18/24.
//

import RxSwift
import Alamofire

final class PostUpdateReqeustRepositoryImpl: PostUpdateReqeustRepository {
    
    func PostUpdateReqeust(type: String, storeID: Int, content: String) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            AF.request(StoreAPI.postUpdateRequest(
                UpdateRequestDTO:
                    UpdateRequestDTO(
                        dtype: type,
                        storeId: storeID,
                        contents: content
                    )
            ))
            .responseDecodable(of: AutoCompletionResponse.self) { response in
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
