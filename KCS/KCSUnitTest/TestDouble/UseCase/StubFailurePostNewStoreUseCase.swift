//
//  StubFailurePostNewStoreUseCase.swift
//  KCSUnitTest
//
//  Created by 김영현 on 3/5/24.
//

@testable import KCS
import RxSwift

struct StubServerFailurePostNewStoreUseCase: PostNewStoreUseCase {
    
    let repository: PostNewStoreRepository
    
    func execute(storeName: String, formattedAddress: String, certifications: [CertificationType]) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            observer.onError(ErrorAlertMessage.server)
            return Disposables.create()
        }
    }
    
}

struct StubClientFailurePostNewStoreUseCase: PostNewStoreUseCase {
    
    let repository: PostNewStoreRepository
    
    func execute(storeName: String, formattedAddress: String, certifications: [CertificationType]) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            observer.onError(NetworkError.wrongURL)
            return Disposables.create()
        }
    }
    
}
