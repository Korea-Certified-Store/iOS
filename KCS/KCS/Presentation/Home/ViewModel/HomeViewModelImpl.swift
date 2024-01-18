//
//  HomeViewModelImpl.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import RxRelay
import RxSwift

final class HomeViewModelImpl: HomeViewModel {
    
    let fetchStoresUseCase: FetchStoresUseCase
    let getStoreInfoUseCase: GetStoreInfoUseCase
    let getFilteredStoresUseCase: GetFilteredStoresUseCase
    private let disposeBag = DisposeBag()
    
    var getStoreInfoComplete = PublishRelay<Store>()
    var refreshComplete = PublishRelay<[FilteredStores]>()
    
    let dependency: HomeDependency
    
    init(
        dependency: HomeDependency,
        fetchStoresUseCase: FetchStoresUseCase,
        getStoreInfoUseCase: GetStoreInfoUseCase,
        getFilteredStoresUseCase: GetFilteredStoresUseCase
    ) {
        self.dependency = dependency
        self.fetchStoresUseCase = fetchStoresUseCase
        self.getStoreInfoUseCase = getStoreInfoUseCase
        self.getFilteredStoresUseCase = getFilteredStoresUseCase
    }
    
    func refresh(
        northWestLocation: Location,
        southEastLocation: Location,
        filters: [CertificationType] = [.goodPrice, .exemplary, .safe]
    ) {
        fetchStoresUseCase.execute(northWestLocation: northWestLocation, southEastLocation: southEastLocation)
            .subscribe(
                onNext: { [weak self] _ in
                    self?.applyFilter(filters: filters)
                },
                onError: { error in
                    dump(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func applyFilter(filters: [CertificationType]) {
        refreshComplete.accept(getFilteredStoresUseCase.execute(filters: filters))
    }
    
    func markerTapped(tag: UInt) throws {
        getStoreInfoComplete.accept(
            try getStoreInfoUseCase.execute(tag: tag)
        )
    }
    
}
