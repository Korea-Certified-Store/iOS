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
    
    let fetchRefreshStoresUseCase: FetchRefreshStoresUseCase
    let fetchStoresUseCase: FetchStoresUseCase
    let getStoreInformationUseCase: GetStoreInformationUseCase
    
    let getStoreInformationOutput = PublishRelay<Store>()
    let refreshOutput = PublishRelay<Void>()
    let locationButtonOutput = PublishRelay<NMFMyPositionMode>()
    let locationButtonImageNameOutput = PublishRelay<String>()
    let setMarkerOutput = PublishRelay<MarkerContents>()
    let locationAuthorizationStatusDeniedOutput = PublishRelay<Void>()
    let locationStatusNotDeterminedOutput = PublishRelay<Void>()
    let locationStatusAuthorizedWhenInUse = PublishRelay<Void>()
    let errorAlertOutput = PublishRelay<ErrorAlertMessage>()
    let applyFiltersOutput = PublishRelay<[FilteredStores]>()
    let dimViewTapGestureEndedOutput = PublishRelay<Void>()
    
    var dependency: HomeDependency
    
    init(
        dependency: HomeDependency,
        fetchRefreshStoresUseCase: FetchRefreshStoresUseCase,
        fetchStoresUseCase: FetchStoresUseCase,
        getStoreInformationUseCase: GetStoreInformationUseCase
    ) {
        self.dependency = dependency
        self.fetchRefreshStoresUseCase = fetchRefreshStoresUseCase
        self.fetchStoresUseCase = fetchStoresUseCase
        self.getStoreInformationUseCase = getStoreInformationUseCase
    }
    
    func action(input: HomeViewModelInputCase) {
        switch input {
        case .refresh(let requestLocation):
            refresh(requestLocation: requestLocation)
        case .filterButtonTapped(let filter, let fetchCount):
            filterButtonTapped(filter: filter, fetchCount: fetchCount)
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
        case .checkLocationAuthorizationWhenCameraDidChange(let status):
            checkLocationAuthorizationWhenCameraDidChange(status: status)
        }
    }
    
}

private extension HomeViewModelImpl {
    
    func refresh(
        requestLocation: RequestLocation
    ) {
        fetchRefreshStoresUseCase.execute(
            requestLocation: requestLocation
        )
        .subscribe(
            onNext: { [weak self] stores in
                guard let self = self else { return }
                applyFilters(stores: stores, filters: getActivatedTypes())
                refreshOutput.accept(())
            },
            onError: { [weak self] error in
                if error is StoreRepositoryError {
                    self?.errorAlertOutput.accept(.data)
                } else {
                    self?.errorAlertOutput.accept(.server)
                }
            }
        )
        .disposed(by: dependency.disposeBag)
    }
    
    func filterButtonTapped(filter: CertificationType, fetchCount: Int) {
        if let lastIndex = dependency.activatedFilter.lastIndex(of: filter) {
            dependency.activatedFilter.remove(at: lastIndex)
        } else {
            dependency.activatedFilter.append(filter)
        }
        applyFilters(stores: fetchStoresUseCase.execute(fetchCount: fetchCount), filters: getActivatedTypes())
    }
    
    func getActivatedTypes() -> [CertificationType] {
        if dependency.activatedFilter.isEmpty {
            return [.safe, .exemplary, .goodPrice]
        }
        
        return dependency.activatedFilter
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
        applyFiltersOutput.accept([goodPriceStores, exemplaryStores, safeStores])
    }
    
    func markerTapped(tag: UInt) {
        do {
            getStoreInformationOutput.accept(
                try getStoreInformationUseCase.execute(tag: tag)
            )
        } catch {
            errorAlertOutput.accept(.data)
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
            locationAuthorizationStatusDeniedOutput.accept(())
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
            locationStatusAuthorizedWhenInUse.accept(())
        default:
            break
        }
    }
    
    func checkLocationAuthorizationWhenCameraDidChange(status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted, .notDetermined:
            locationButtonImageNameOutput.accept("LocationButtonNone")
        case .authorizedWhenInUse:
            locationButtonImageNameOutput.accept("LocationButtonNormal")
        default:
            break
        }
    }
    
}
