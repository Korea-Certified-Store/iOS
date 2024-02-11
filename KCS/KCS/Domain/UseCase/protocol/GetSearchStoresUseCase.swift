//
//  GetSearchStoresUseCase.swift
//  KCS
//
//  Created by 조성민 on 2/9/24.
//

import RxSwift

protocol GetSearchStoresUseCase {
    
    var repository: FetchSearchStoresRepository { get }
    
    init(repository: FetchSearchStoresRepository)
    
    func execute(
        location: Location,
        keyword: String
    ) -> Observable<[Store]>
    
}
