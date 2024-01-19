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

enum HomeViewModelInputCase {
    
    case refresh(
        northWestLocation: Location,
        southEastLocation: Location,
        filters: [CertificationType]
    )
    case fetchFilteredStores(
        filters: [CertificationType]
    )
    case markerTapped(
        tag: UInt
    )
    
}

protocol HomeViewModelInput {
    
    func action(input: HomeViewModelInputCase)
    
}

protocol HomeViewModelOutput {
    
    var getStoreInfoComplete: PublishRelay<Store> { get }
    var refreshComplete: PublishRelay<[FilteredStores]> { get }
    
}
