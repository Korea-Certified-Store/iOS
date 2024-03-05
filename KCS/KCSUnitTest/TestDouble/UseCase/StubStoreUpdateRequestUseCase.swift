//
//  StubStoreUpdateRequestUseCase.swift
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

struct StubInternetFailureStoreUpdateRequestUseCase: StoreUpdateRequestUseCase {
    
    let repository: StoreUpdateRequestRepository
    
    init(repository: StoreUpdateRequestRepository = StoreUpdateRequestRepositoryImpl(session: Session.default)) {
        self.repository = repository
    }
    
    func execute(type: StoreUpdateRequestType, storeID: Int, content: String) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            observer.onError(ErrorAlertMessage.internet)
            
            return Disposables.create()
        }
    }
    
}

struct StubServerFailureStoreUpdateRequestUseCase: StoreUpdateRequestUseCase {
    
    let repository: StoreUpdateRequestRepository
    
    init(repository: StoreUpdateRequestRepository = StoreUpdateRequestRepositoryImpl(session: Session.default)) {
        self.repository = repository
    }
    
    func execute(type: StoreUpdateRequestType, storeID: Int, content: String) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            observer.onError(ErrorAlertMessage.server)
            
            return Disposables.create()
        }
    }
    
}

struct StubClientFailureStoreUpdateRequestUseCase: StoreUpdateRequestUseCase {
    
    let repository: StoreUpdateRequestRepository
    
    init(repository: StoreUpdateRequestRepository = StoreUpdateRequestRepositoryImpl(session: Session.default)) {
        self.repository = repository
    }
    
    func execute(type: StoreUpdateRequestType, storeID: Int, content: String) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            observer.onError(ErrorAlertMessage.client)
            
            return Disposables.create()
        }
    }
    
}

struct StubAlamofireFailureStoreUpdateRequestUseCase: StoreUpdateRequestUseCase {
    
    let repository: StoreUpdateRequestRepository
    
    init(repository: StoreUpdateRequestRepository = StoreUpdateRequestRepositoryImpl(session: Session.default)) {
        self.repository = repository
    }
    
    func execute(type: StoreUpdateRequestType, storeID: Int, content: String) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            observer.onError(ErrorAlertMessage.client)
            
            return Disposables.create()
        }
    }
    
}

