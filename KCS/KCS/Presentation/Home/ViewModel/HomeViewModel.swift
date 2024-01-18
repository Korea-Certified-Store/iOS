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
    
    init(
        dependency: HomeDependency,
        fetchRefreshStoresUseCase: FetchRefreshStoresUseCase,
        fetchStoresUseCase: FetchStoresUseCase
    )
    
}

protocol HomeViewModelInput {
    
    func refresh(
        northWestLocation: Location,
        southEastLocation: Location,
        filters: [CertificationType]
    ) 
    func fetchFilteredStores(filters: [CertificationType])
    
}

protocol HomeViewModelOutput {
    
    var refreshComplete: PublishRelay<[FilteredStores]> { get }
    
}
