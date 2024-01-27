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
            case .refresh(let requestLocation, let filters):
                refresh(
                    requestLocation: requestLocation,
                    filters: filters
                )
            case .fetchFilteredStores(let filters):
                fetchFilteredStores(filters: filters)
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
        requestLocation: RequestLocation,
        filters: [CertificationType] = [.goodPrice, .exemplary, .safe]
    ) {
        fetchRefreshStoresUseCase.execute(
            requestLocation: requestLocation
        )
        .subscribe(
            onNext: { [weak self] stores in
                self?.applyFilters(stores: stores, filters: filters)
            },
            onError: { error in
                print(error.localizedDescription)
            }
        )
        .disposed(by: dependency.disposeBag)
    }
    
    func fetchFilteredStores(filters: [CertificationType]) {
        applyFilters(stores: fetchStoresUseCase.execute(), filters: filters)
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
            dependency.state = .detail
        } else if height > 230 && height <= 420 {
            storeInformationViewHeightOutput.accept(
                StoreInformationViewConstraints(
                    heightConstraint: height,
                    bottomConstraint: -16
                )
            )
            detailToSummaryOutput.accept(())
            dependency.state = .summary
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
            dependency.state = .detail
        } else {
            storeInformationViewHeightOutput.accept(
                StoreInformationViewConstraints(
                    heightConstraint: dependency.storeInformationOriginalHeight,
                    bottomConstraint: -16,
                    animated: true
                )
            )
            detailToSummaryOutput.accept(())
            dependency.state = .summary
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
            dependency.state = .detail
        } else if velocity > 1000 {
            storeInformationViewHeightOutput.accept(
                StoreInformationViewConstraints(
                    heightConstraint: dependency.storeInformationOriginalHeight,
                    bottomConstraint: -16,
                    animated: true
                )
            )
            detailToSummaryOutput.accept(())
            dependency.state = .summary
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
            dependency.state = .detail
        }
    }
    
    func changeState(state: HomeViewState) {
        dependency.state = state
    }
}
