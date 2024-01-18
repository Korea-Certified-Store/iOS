//
//  HomeViewModel.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import RxCocoa

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput {
    
    var dependency: HomeDependency { get }
    
    var fetchStoresUseCase: FetchStoresUseCase { get }
    var getStoreInfoUseCase: GetStoreInfoUseCase { get }
    var getFilteredStoresUseCase: GetFilteredStoresUseCase { get }
    
    init(
        dependency: HomeDependency,
        fetchStoresUseCase: FetchStoresUseCase,
        getStoreInfoUseCase: GetStoreInfoUseCase,
        getFilteredStoresUseCase: GetFilteredStoresUseCase
    )
    
}

protocol HomeViewModelInput {
    
    func refresh(
        northWestLocation: Location,
        southEastLocation: Location,
        filters: [CertificationType]
    )
    func applyFilter(filters: [CertificationType])
    func markerTapped(tag: UInt)
    
}

protocol HomeViewModelOutput {
    
    var getStoreInfoComplete: PublishRelay<Store?> { get }
    var refreshComplete: PublishRelay<[FilteredStores]> { get }
    
}
