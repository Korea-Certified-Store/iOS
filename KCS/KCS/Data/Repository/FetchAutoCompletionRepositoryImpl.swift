//
//  FetchAutoCompletionRepositoryImpl.swift
//  KCS
//
//  Created by 김영현 on 2/17/24.
//

import RxSwift
import Alamofire

final class FetchAutoCompletionRepositoryImpl: FetchAutoCompletionRepository {
    
    let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func fetchAutoCompletion(
        searchKeyword: String
    ) -> Observable<[String]> {
        return Observable<[String]>.create { [weak self] observer -> Disposable in
            self?.session.request(StoreAPI.getAutoCompletion(
                autoCompletionDTO: AutoCompletionDTO(
                    searchKeyword: searchKeyword
                )))
            .responseDecodable(of: AutoCompletionResponse.self) { response in
                switch response.result {
                case .success(let result):
                    let autoCompletion = result.data
                    observer.onNext(autoCompletion)
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
