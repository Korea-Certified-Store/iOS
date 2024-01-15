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
    init(dependency: HomeDependency, getStoresUseCase: FetchStoresUseCase)
    
}

protocol HomeViewModelInput {
    
    func refresh(
        northWestLocation: Location,
        southEastLocation: Location,
        types: [CertificationType]
    ) 
    func filterChange(type: CertificationType)
    
}

protocol HomeViewModelOutput {
    
    var storesLoaded: PublishRelay<[Store]> { get }
    
}
