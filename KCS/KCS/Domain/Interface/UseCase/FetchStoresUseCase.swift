//
//  FetchStoresUseCase.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import RxSwift

protocol FetchStoresUseCase {
    
    func execute(
        northWestLocation: Location,
        southEastLocation: Location
    ) -> Observable<Void>

}
