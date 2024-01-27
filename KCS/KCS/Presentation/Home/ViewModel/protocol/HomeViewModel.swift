//
//  HomeViewModel.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import RxCocoa
import NMapsMap

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput {
    
    var dependency: HomeDependency { get }
    
    var fetchRefreshStoresUseCase: FetchRefreshStoresUseCase { get }
    var fetchStoresUseCase: FetchStoresUseCase { get }
    var getStoreInformationUseCase: GetStoreInformationUseCase { get }
    
    init(
        dependency: HomeDependency,
        fetchRefreshStoresUseCase: FetchRefreshStoresUseCase,
        fetchStoresUseCase: FetchStoresUseCase,
        getStoreInformationUseCase: GetStoreInformationUseCase
    )
    
}

enum HomeViewModelInputCase {
    
    case refresh(
        requestLocation: RequestLocation,
        filters: [CertificationType]
    )
    case fetchFilteredStores(
        filters: [CertificationType]
    )
    case markerTapped(tag: UInt)
    case locationButtonTapped(positionMode: NMFMyPositionMode)
    
}

protocol HomeViewModelInput {
    
    func action(input: HomeViewModelInputCase)
    
}

protocol HomeViewModelOutput {
    
    var getStoreInformationOutput: PublishRelay<Store> { get }
    var refreshOutput: PublishRelay<[FilteredStores]> { get }
    var locationButtonOutput: PublishRelay<LocationButton> { get }
    
}
