//
//  HomeViewModelImpl.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import RxRelay
import RxSwift
import CoreLocation
import NMapsMap

final class HomeViewModelImpl: HomeViewModel {
    
    let dependency: HomeDependency
    
    let getStoreInformationOutput = PublishRelay<Store>()
    let refreshDoneOutput = PublishRelay<Bool>()
    let locationButtonOutput = PublishRelay<NMFMyPositionMode>()
    let setMarkerOutput = PublishRelay<MarkerContents>()
    let locationAuthorizationStatusDeniedOutput = PublishRelay<Void>()
    let locationStatusNotDeterminedOutput = PublishRelay<Void>()
    let locationStatusAuthorizedWhenInUseOutput = PublishRelay<Void>()
    let requestLocationAuthorizationOutput = PublishRelay<Void>()
    let errorAlertOutput = PublishRelay<ErrorAlertMessage>()
    let filteredStoresOutput = PublishRelay<[FilteredStores]>()
    let fetchCountOutput = PublishRelay<FetchCountContent>()
    let noMoreStoresOutput = PublishRelay<Void>()
    let dimViewTapGestureEndedOutput = PublishRelay<Void>()
    let searchStoresOutput = PublishRelay<[Store]>()
    let searchOneStoreOutput = PublishRelay<Store>()
    let moreStoreButtonHiddenOutput = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    // TODO: activatedFilter 수정 필요
    private var activatedFilter: [CertificationType] = []
    private var fetchCount: Int = 1
    private var maxFetchCount: Int = 1
    
    init(dependency: HomeDependency) {
        self.dependency = dependency
    }
    
    func action(input: HomeViewModelInputCase) {
        switch input {
        case .refresh(let requestLocation, let isEntire):
            refresh(requestLocation: requestLocation, isEntire: isEntire)
        case .moreStoreButtonTapped:
            moreStoreButtonTapped()
        case .filterButtonTapped(let filter):
            filterButtonTapped(filter: filter)
        case .markerTapped(let tag):
            markerTapped(tag: tag)
        case .locationButtonTapped(let locationAuthorizationStatus, let positionMode):
            locationButtonTapped(locationAuthorizationStatus: locationAuthorizationStatus, positionMode: positionMode)
        case .dimViewTapGestureEnded:
            dimViewTapGestureEnded()
        case .setMarker(let store, let certificationType):
            setMarker(store: store, certificationType: certificationType)
        case .checkLocationAuthorization(let status):
            checkLocationAuthorization(status: status)
        case .search(let location, let keyword):
            search(location: location, keyword: keyword)
        case .resetFilters:
            resetFilters()
        case .compareCameraPosition(let refreshCameraPosition, let endMoveCameraPosition, let refreshCameraPoint, let endMoveCameraPoint):
            compareCameraPosition(
                refreshCameraPosition: refreshCameraPosition,
                endMoveCameraPosition: endMoveCameraPosition,
                refreshCameraPoint: refreshCameraPoint,
                endMoveCameraPoint: endMoveCameraPoint
            )
        }
    }
    
}

private extension HomeViewModelImpl {
    
    func refresh(
        requestLocation: RequestLocation,
        isEntire: Bool
    ) {
        dependency.getStoresUseCase.execute(
            requestLocation: requestLocation,
            isEntire: isEntire
        )
        .subscribe(
            onNext: { [weak self] refreshContent in
                guard let self = self else { return }
                resetFetchCount()
                maxFetchCount = refreshContent.fetchCountContent.maxFetchCount
                applyFilters(stores: refreshContent.stores, filters: getActivatedTypes())
                fetchCountOutput.accept(FetchCountContent(maxFetchCount: maxFetchCount))
                refreshDoneOutput.accept(isEntire)
                checkLastFetch()
            },
            onError: { [weak self] error in
                if error is StoreRepositoryError {
                    self?.errorAlertOutput.accept(.client)
                } else {
                    guard let error = error as? ErrorAlertMessage else { return }
                    self?.errorAlertOutput.accept(error)
                    self?.refreshDoneOutput.accept(true)
                }
            }
        )
        .disposed(by: disposeBag)
    }
    
    func moreStoreButtonTapped() {
        if fetchCount < maxFetchCount {
            fetchCount += 1
            applyFilters(
                stores: dependency.getRefreshStoresUseCase.execute(fetchCount: fetchCount),
                filters: getActivatedTypes()
            )
            fetchCountOutput.accept(FetchCountContent(maxFetchCount: maxFetchCount, fetchCount: fetchCount))
        }
        checkLastFetch()
    }
    
    func checkLastFetch() {
        if fetchCount == maxFetchCount {
            noMoreStoresOutput.accept(())
        }
    }
    
    func filterButtonTapped(filter: CertificationType) {
        if let lastIndex = activatedFilter.lastIndex(of: filter) {
            activatedFilter.remove(at: lastIndex)
        } else {
            activatedFilter.append(filter)
        }
        applyFilters(stores: dependency.getRefreshStoresUseCase.execute(fetchCount: fetchCount), filters: getActivatedTypes())
    }
    
    func getActivatedTypes() -> [CertificationType] {
        if activatedFilter.isEmpty {
            return [.safe, .exemplary, .goodPrice]
        }
        
        return activatedFilter
    }
    
    func applyFilters(stores: [Store], filters: [CertificationType]) {
        var goodPriceStores = FilteredStores(
            type: .goodPrice,
            stores: []
        )
        var exemplaryStores = FilteredStores(
            type: .exemplary,
            stores: []
        )
        var safeStores = FilteredStores(
            type: .safe,
            stores: []
        )
        
        stores.forEach { store in
            var type: CertificationType?
            filters.forEach { filter in
                if store.certificationTypes.contains(filter) {
                    type = filter
                }
            }
            if let checkedType = type {
                switch checkedType {
                case .goodPrice:
                    goodPriceStores.stores.append(store)
                case .exemplary:
                    exemplaryStores.stores.append(store)
                case .safe:
                    safeStores.stores.append(store)
                }
            }
        }
        filteredStoresOutput.accept([goodPriceStores, exemplaryStores, safeStores])
    }
    
    func markerTapped(tag: UInt) {
        do {
            getStoreInformationOutput.accept(
                try dependency.getStoreInformationUseCase.execute(tag: tag)
            )
        } catch {
            errorAlertOutput.accept(.client)
        }
    }
    
    func setMarker(store: Store, certificationType: CertificationType) {
        switch certificationType {
        case .goodPrice:
            setMarkerOutput.accept(
                MarkerContents(
                    tag: store.id,
                    location: store.location,
                    deselectImageName: "MarkerGoodPriceNormal",
                    selectImageName: "MarkerGoodPriceSelected"
                )
            )
        case .exemplary:
            setMarkerOutput.accept(
                MarkerContents(
                    tag: store.id,
                    location: store.location,
                    deselectImageName: "MarkerExemplaryNormal",
                    selectImageName: "MarkerExemplarySelected"
                )
            )
        case .safe:
            setMarkerOutput.accept(
                MarkerContents(
                    tag: store.id,
                    location: store.location,
                    deselectImageName: "MarkerSafeNormal",
                    selectImageName: "MarkerSafeSelected"
                )
            )
        }
    }
    
    func locationButtonTapped(locationAuthorizationStatus: CLAuthorizationStatus, positionMode: NMFMyPositionMode) {
        if locationAuthorizationStatus == .denied {
            requestLocationAuthorizationOutput.accept(())
        }
        switch positionMode {
        case .direction:
            locationButtonOutput.accept(.compass)
        case .compass, .normal:
            locationButtonOutput.accept(.direction)
        default:
            break
        }
    }
    
    func dimViewTapGestureEnded() {
        dimViewTapGestureEndedOutput.accept(())
    }
    
    func checkLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationStatusNotDeterminedOutput.accept(())
        case .authorizedWhenInUse:
            locationStatusAuthorizedWhenInUseOutput.accept(())
        default:
            locationAuthorizationStatusDeniedOutput.accept(())
        }
    }
    
    func search(location: Location, keyword: String) {
        dependency.getSearchStoresUseCase
            .execute(location: location, keyword: keyword)
            .subscribe(onNext: { [weak self] stores in
                guard let self = self else { return }
                fetchCount = stores.count
                if stores.count == 1 {
                    guard let oneStore = stores.first else { return }
                    searchOneStoreOutput.accept(oneStore)
                } else {
                    searchStoresOutput.accept(stores)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func compareCameraPosition(
        refreshCameraPosition: NMFCameraPosition,
        endMoveCameraPosition: NMFCameraPosition,
        refreshCameraPoint: CGPoint,
        endMoveCameraPoint: CGPoint
    ) {
        let zoomDifference = abs(refreshCameraPosition.zoom - endMoveCameraPosition.zoom)
        let pointDifference = sqrt(
            pow(refreshCameraPoint.x - endMoveCameraPoint.x, 2) +
            pow(refreshCameraPoint.y - endMoveCameraPoint.y, 2)
        )
        if zoomDifference > 0.5 || pointDifference > 50 {
            moreStoreButtonHiddenOutput.accept(())
        }
    }
    
    func resetFilters() {
        activatedFilter = []
    }
    
    func resetFetchCount() {
        fetchCount = 1
    }
    
}
