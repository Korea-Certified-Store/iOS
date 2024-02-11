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
    
    var getStoresUseCase: GetStoresUseCase { get }
    var getRefreshStoresUseCase: GetRefreshStoresUseCase { get }
    var getStoreInformationUseCase: GetStoreInformationUseCase { get }
    var getSearchStoresUseCase: GetSearchStoresUseCase { get }
    
    init(
        dependency: HomeDependency,
        getStoresUseCase: GetStoresUseCase,
        getRefreshStoresUseCase: GetRefreshStoresUseCase,
        getStoreInformationUseCase: GetStoreInformationUseCase,
        getSearchStoresUseCase: GetSearchStoresUseCase
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
    case search(location: Location, keyword: String)
    case resetFilters
    case compareCameraPosition(
        refreshCameraPosition: NMFCameraPosition,
        endMoveCameraPosition: NMFCameraPosition,
        refreshCameraPoint: CGPoint,
        endMoveCameraPoint: CGPoint
    )
    
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
    var locationStatusAuthorizedWhenInUseOutput: PublishRelay<Void> { get }
    var errorAlertOutput: PublishRelay<ErrorAlertMessage> { get }
    var fetchCountOutput: PublishRelay<FetchCountContent> { get }
    var noMoreStoresOutput: PublishRelay<Void> { get }
    var dimViewTapGestureEndedOutput: PublishRelay<Void> { get }
    var searchStoresOutput: PublishRelay<[Store]> { get }
    var searchOneStoreOutput: PublishRelay<Store> { get }
    var moreStoreButtonHiddenOutput: PublishRelay<Void> { get }
    
}
