//
//  StubSuccessPostNewStoreUseCase.swift
//  KCSUnitTest
//
//  Created by 김영현 on 3/4/24.
//

@testable import KCS
import RxSwift

struct StubSuccessPostNewStoreUseCase: PostNewStoreUseCase {
    
    var repository: PostNewStoreRepository
    
    func execute(storeName: String, formattedAddress: String, certifications: [CertificationType]) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            observer.onNext(())
            return Disposables.create()
        }
    }
    
}
