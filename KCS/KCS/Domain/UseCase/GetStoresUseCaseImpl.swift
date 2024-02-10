//
//  GetStoresUseCaseImpl.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import RxSwift

struct GetStoresUseCaseImpl: GetStoresUseCase {
    
    let repository: FetchStoresRepository
    
    func execute(
        requestLocation: RequestLocation,
        isEntire: Bool
    ) -> Observable<FetchStores> {
        return repository.fetchStores(requestLocation: requestLocation, isEntire: isEntire)
    }
    
}
