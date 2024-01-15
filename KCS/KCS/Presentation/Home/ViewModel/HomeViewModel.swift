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
    
    init(
        dependency: HomeDependency,
        fetchStoresUseCase: FetchStoresUseCase,
        getStoresUseCase: GetStoresUseCase
    )
    
}

protocol HomeViewModelInput {
    
    func refresh(
        northWestLocation: Location,
        southEastLocation: Location,
        types: [CertificationType]
    ) 
    func applyFilter(type: CertificationType)
    
}

protocol HomeViewModelOutput {
    
    var storesLoaded: PublishRelay<[Store]> { get }
    
}
