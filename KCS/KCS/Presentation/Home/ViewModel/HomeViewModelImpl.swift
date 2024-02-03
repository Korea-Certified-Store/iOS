//
//  HomeViewModelImpl.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import RxRelay
import RxSwift

final class HomeViewModelImpl: HomeViewModel {
    
    let fetchRefreshStoresUseCase: FetchRefreshStoresUseCase
    let fetchStoresUseCase: FetchStoresUseCase
    let getStoreInformationUseCase: GetStoreInformationUseCase
    
    private let disposeBag = DisposeBag()
    
    var getStoreInformationOutput = PublishRelay<Store>()
    var refreshOutput = PublishRelay<[FilteredStores]>()
    
    let dependency: HomeDependency
    
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
        .disposed(by: disposeBag)
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
    
}
