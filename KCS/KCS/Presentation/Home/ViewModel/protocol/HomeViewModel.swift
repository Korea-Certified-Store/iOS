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
    
    case refresh(requestLocation: RequestLocation, isEntire: Bool = false)
    case moreStoreButtonTapped
    case filterButtonTapped(activatedFilter: CertificationType)
    case markerTapped(tag: UInt)
    case locationButtonTapped(locationAuthorizationStatus: CLAuthorizationStatus, positionMode: NMFMyPositionMode)
    case dimViewTapGestureEnded
    case setMarker(store: Store, certificationType: CertificationType)
    case checkLocationAuthorization(status: CLAuthorizationStatus)
    case checkLocationAuthorizationWhenCameraDidChange(status: CLAuthorizationStatus)
    case search(keyword: String)
    
}

protocol HomeViewModelInput {
    
    func action(input: HomeViewModelInputCase)
    
}

protocol HomeViewModelOutput {
    
    var getStoreInformationOutput: PublishRelay<Store> { get }
    var refreshDoneOutput: PublishRelay<Bool> { get }
    var filteredStoresOutput: PublishRelay<[FilteredStores]> { get }
    var locationButtonOutput: PublishRelay<NMFMyPositionMode> { get }
    var locationButtonImageNameOutput: PublishRelay<String> { get }
    var setMarkerOutput: PublishRelay<MarkerContents> { get }
    var locationAuthorizationStatusDeniedOutput: PublishRelay<Void> { get }
    var locationStatusNotDeterminedOutput: PublishRelay<Void> { get }
    var locationStatusAuthorizedWhenInUse: PublishRelay<Void> { get }
    var errorAlertOutput: PublishRelay<ErrorAlertMessage> { get }
    var fetchCountOutput: PublishRelay<FetchCountContent> { get }
    var noMoreStoresOutput: PublishRelay<Void> { get }
    var dimViewTapGestureEndedOutput: PublishRelay<Void> { get }
    
}
