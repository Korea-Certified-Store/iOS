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
    var getStoresUseCase: GetStoresUseCase { get }
    var getStoreInfoUseCase: GetStoreInfoUseCase { get }
    
    init(
        dependency: HomeDependency,
        fetchStoresUseCase: FetchStoresUseCase,
        getStoresUseCase: GetStoresUseCase,
        getStoreInfoUseCase: GetStoreInfoUseCase
    )
    
}

protocol HomeViewModelInput {
    
    func refresh(
        northWestLocation: Location,
        southEastLocation: Location,
        types: [CertificationType]
    ) 
    func applyFilter(types: [CertificationType])
    func markerTapped(tag: UInt)
    
}

protocol HomeViewModelOutput {
    
    var refreshComplete: PublishRelay<LoadedStores> { get }
    var getStoreInfoComplete: PublishRelay<Store?> { get }
    
}
