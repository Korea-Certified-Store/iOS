//
//  StoreRepository.swift
//  KCS
//
//  Created by 조성민 on 1/11/24.
//

import RxSwift

protocol StoreRepository {
    
    func fetchStores(
        northWestLocation: Location,
        southEastLocation: Location
    ) -> Observable<[Store]>
    
}
