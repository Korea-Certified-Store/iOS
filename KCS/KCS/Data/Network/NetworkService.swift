//
//  NetworkService.swift
//  KCS
//
//  Created by 조성민 on 1/12/24.
//

import Alamofire
import RxSwift

final class NetworkService {
    
    static let shared = NetworkService()
    
    func getStores(location: RequestLocationDTO) -> Observable<Result<StoreResponse, Error>> {
        return Observable.create { observer -> Disposable in
            AF.request(StoreAPI.getStores(location: location))
                .responseDecodable(of: StoreResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
    
}
