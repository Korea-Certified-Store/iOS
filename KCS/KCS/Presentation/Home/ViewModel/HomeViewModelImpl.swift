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
    
    var getStoreInformationOutput = PublishRelay<Store>()
    var refreshOutput = PublishRelay<[FilteredStores]>()
    var locationButtonOutput = PublishRelay<NMFMyPositionMode>()
    var storeInformationViewHeightOutput = PublishRelay<StoreInformationViewConstraints>()
    var summaryToDetailOutput = PublishRelay<Void>()
    var detailToSummaryOutput = PublishRelay<Void>()
    
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
        do {
            switch input {
            case .refresh(let requestLocation):
                refresh(requestLocation: requestLocation)
            case .filterButtonTapped(let filter):
                filterButtonTapped(filter: filter)
            case .markerTapped(let tag):
                try markerTapped(tag: tag)
            case .locationButtonTapped(let positionMode):
                setLocationButtonImage(positionMode: positionMode)
            case .setStoreInformationOriginalHeight(let height):
                setStoreInformationOriginalHeight(height: height)
            case .storeInformationViewPanGestureChanged(let height):
                storeInformationViewPanGestureChanged(height: height)
            case .storeInformationViewPanGestureEnded(let height):
                storeInformationViewPanGestureEnded(height: height)
            case .storeInformationViewSwipe(let velocity):
                storeInformationViewSwipe(velocity: velocity)
            case .storeInformationViewTapGestureEnded:
                storeInformationViewTapGestureEnded()
            case .dimViewTapGestureEnded:
                dimViewTapGestureEnded()
            case .changeState(let state):
                changeState(state: state)
            }
        } catch {
            print(error.localizedDescription)
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
            },
            onError: { error in
                print(error.localizedDescription)
            }
        )
        .disposed(by: dependency.disposeBag)
    }
    
    func filterButtonTapped(filter: CertificationType) {
        if let lastIndex = dependency.activatedFilter.lastIndex(of: filter) {
            dependency.activatedFilter.remove(at: lastIndex)
        } else {
            dependency.activatedFilter.append(filter)
        }
        applyFilters(stores: fetchStoresUseCase.execute(), filters: getActivatedTypes())
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
        refreshOutput.accept([goodPriceStores, exemplaryStores, safeStores])
    }
    
    func markerTapped(tag: UInt) throws {
        getStoreInformationOutput.accept(
            try getStoreInformationUseCase.execute(tag: tag)
        )
    }
    
    func setLocationButtonImage(positionMode: NMFMyPositionMode) {
        switch positionMode {
        case .direction:
            locationButtonOutput.accept(.compass)
        case .compass, .normal:
            locationButtonOutput.accept(.direction)
        default:
            break
        }
    }
    
    func setStoreInformationOriginalHeight(height: CGFloat) {
        dependency.storeInformationOriginalHeight = height
    }
    
    func storeInformationViewPanGestureChanged(height: CGFloat) {
        if height > 420 && height < 630 {
            // TODO: 441은 420에서 bottomSafeArea 길이인 21만큼 더해준 값이다.
            storeInformationViewHeightOutput.accept(
                StoreInformationViewConstraints(
                    heightConstraint: height,
                    bottomConstraint: height - 441
                )
            )
            summaryToDetailOutput.accept(())
        } else if height > 230 && height <= 420 {
            storeInformationViewHeightOutput.accept(
                StoreInformationViewConstraints(
                    heightConstraint: height,
                    bottomConstraint: -16
                )
            )
            detailToSummaryOutput.accept(())
        }
    }
    
    func storeInformationViewPanGestureEnded(height: CGFloat) {
        if height > 420 {
            storeInformationViewHeightOutput.accept(
                StoreInformationViewConstraints(
                    heightConstraint: 616,
                    bottomConstraint: 616 - 441,
                    animated: true
                )
            )
            summaryToDetailOutput.accept(())
        } else {
            storeInformationViewHeightOutput.accept(
                StoreInformationViewConstraints(
                    heightConstraint: dependency.storeInformationOriginalHeight,
                    bottomConstraint: -16,
                    animated: true
                )
            )
            detailToSummaryOutput.accept(())
        }
    }
    
    func storeInformationViewSwipe(velocity: Double) {
        if velocity < -1000 {
            storeInformationViewHeightOutput.accept(
                StoreInformationViewConstraints(
                    heightConstraint: 616,
                    bottomConstraint: 616 - 441,
                    animated: true
                )
            )
            summaryToDetailOutput.accept(())
        } else if velocity > 1000 {
            storeInformationViewHeightOutput.accept(
                StoreInformationViewConstraints(
                    heightConstraint: dependency.storeInformationOriginalHeight,
                    bottomConstraint: -16,
                    animated: true
                )
            )
            detailToSummaryOutput.accept(())
        }
    }
    
    func storeInformationViewTapGestureEnded() {
        if dependency.state == .summary {
            storeInformationViewHeightOutput.accept(
                StoreInformationViewConstraints(
                    heightConstraint: 616,
                    bottomConstraint: 616 - 441,
                    animated: true
                )
            )
            summaryToDetailOutput.accept(())
        }
    }
    
    func dimViewTapGestureEnded() {
        storeInformationViewHeightOutput.accept(
            StoreInformationViewConstraints(
                heightConstraint: dependency.storeInformationOriginalHeight,
                bottomConstraint: -16,
                animated: true
            )
        )
        detailToSummaryOutput.accept(())
    }
    
    func changeState(state: HomeViewState) {
        dependency.state = state
    }
}
