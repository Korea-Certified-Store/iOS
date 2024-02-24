//
//  FetchAutoCompletionRepositoryImpl.swift
//  KCS
//
//  Created by 김영현 on 2/17/24.
//

import RxSwift
import Alamofire

final class FetchAutoCompletionRepositoryImpl: FetchAutoCompletionRepository {
    
    let storeAPI: StoreAPI<AutoCompletionDTO>
    
    init(storeAPI: StoreAPI<AutoCompletionDTO>) {
        self.storeAPI = storeAPI
    }
    
    func fetchAutoCompletion(
        searchKeyword: String
    ) -> Observable<[String]> {
        return Observable<[String]>.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let urlRequest = storeAPI.execute(
                    requestValue: AutoCompletionDTO(
                        searchKeyword: searchKeyword
                    )
                  ) else { return Disposables.create() }
            AF.request(urlRequest)
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
