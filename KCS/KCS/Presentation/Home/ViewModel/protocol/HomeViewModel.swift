//
//  HomeViewModel.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import RxCocoa

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput {
    
    var dependency: HomeDependency { get }
    
    var fetchRefreshStoresUseCase: FetchRefreshStoresUseCase { get }
    var fetchStoresUseCase: FetchStoresUseCase { get }
    var getStoreInfoUseCase: GetStoreInfoUseCase { get }
    
    init(
        dependency: HomeDependency,
        fetchRefreshStoresUseCase: FetchRefreshStoresUseCase,
        fetchStoresUseCase: FetchStoresUseCase,
        getStoreInfoUseCase: GetStoreInfoUseCase
    )
    
}

protocol HomeViewModelInput {
    
    func refresh(
        northWestLocation: Location,
        southEastLocation: Location,
        filters: [CertificationType]
    ) 
    func fetchFilteredStores(filters: [CertificationType])
    func markerTapped(tag: UInt) throws
}

protocol HomeViewModelOutput {
    
    var getStoreInfoComplete: PublishRelay<Store> { get }
    var refreshComplete: PublishRelay<[FilteredStores]> { get }
    
}
