//
//  GetSearchStoresUseCaseImpl.swift
//  KCS
//
//  Created by 조성민 on 2/9/24.
//

import RxSwift

struct GetSearchStoresUseCaseImpl: GetSearchStoresUseCase {
    
    var repository: FetchSearchStoresRepository
    
    func execute(location: Location, keyword: String) -> Observable<[Store]> {
        return repository.fetchSearchStores(location: location, keyword: keyword)
    }
    
}
