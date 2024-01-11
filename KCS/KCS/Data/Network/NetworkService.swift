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
    
    func getStores(location: RequestLocationDTO) -> Observable<[StoreDTO]> {
        let observable =  Observable<[StoreDTO]>.create { observer -> Disposable in
            
            AF.request(StoreAPI.getStores(location: location))
                .responseDecodable(of: StoreResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        dump(data)
                        observer.onNext(data.data)
                        observer.onCompleted()
                    case .failure(let error):
                        dump(error)
                        observer.onError(error)
                        observer.onCompleted()
                    }
                }
            
            return Disposables.create()
        }
        
        return observable
    }
    
}
