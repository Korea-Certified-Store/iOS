//
//  StubSuccessStoreUpdateRequestUseCase.swift
//  KCSUnitTest
//
//  Created by 조성민 on 3/5/24.
//

@testable import KCS
import RxSwift
import Alamofire

struct StubSuccessStoreUpdateRequestUseCase: StoreUpdateRequestUseCase {
    
    let repository: StoreUpdateRequestRepository
    
    init(repository: StoreUpdateRequestRepository = StoreUpdateRequestRepositoryImpl(session: Session.default)) {
        self.repository = repository
    }
    
    func execute(type: StoreUpdateRequestType, storeID: Int, content: String) -> Observable<Void> {
        return .just(())
    }
    
}
