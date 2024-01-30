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
    
    case refresh(requestLocation: RequestLocation)
    case filterButtonTapped(activatedFilter: CertificationType)
    case markerTapped(tag: UInt)
    case locationButtonTapped(locationAuthorizationStatus: CLAuthorizationStatus, positionMode: NMFMyPositionMode)
    case setStoreInformationOriginalHeight(height: CGFloat)
    case storeInformationViewPanGestureChanged(height: CGFloat)
    case storeInformationViewPanGestureEnded(height: CGFloat)
    case storeInformationViewSwipe(velocity: Double)
    case storeInformationViewTapGestureEnded
    case dimViewTapGestureEnded
    case changeState(state: HomeViewState)
    case setMarker(store: Store, certificationType: CertificationType)
    case checkLocationAuthorization(status: CLAuthorizationStatus)
    case checkLocationAuthorizationWhenCameraDidChange(status: CLAuthorizationStatus)
    
}

protocol HomeViewModelInput {
    
    func action(input: HomeViewModelInputCase)
    
}

protocol HomeViewModelOutput {
    
    var getStoreInformationOutput: PublishRelay<Store> { get }
    var refreshOutput: PublishRelay<[FilteredStores]> { get }
    var locationButtonOutput: PublishRelay<NMFMyPositionMode> { get }
    var locationButtonImageNameOutput: PublishRelay<String> { get }
    var storeInformationViewHeightOutput: PublishRelay<StoreInformationViewConstraints> { get }
    var summaryToDetailOutput: PublishRelay<Void> { get }
    var detailToSummaryOutput: PublishRelay<Void> { get }
    var setMarkerOutput: PublishRelay<MarkerContents> { get }
    var locationAuthorizationStatusDeniedOutput: PublishRelay<Void> { get }
    var locationStatusNotDeterminedOutput: PublishRelay<Void> { get }
    var locationStatusAuthorizedWhenInUse: PublishRelay<Void> { get }
    var errorAlertOutput: PublishRelay<ErrorAlertMessage> { get }
    
}
