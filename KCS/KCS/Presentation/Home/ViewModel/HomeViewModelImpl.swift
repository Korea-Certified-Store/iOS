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
    let getStoresUseCase: GetStoresUseCase
    let getStoreInfoUseCase: GetStoreInfoUseCase
    private let disposeBag = DisposeBag()
    
    var refreshComplete = PublishRelay<LoadedStores>()
    var getStoreInfoComplete = PublishRelay<Store?>()
    
    let dependency: HomeDependency
    
    init(
        dependency: HomeDependency,
        fetchStoresUseCase: FetchStoresUseCase,
        getStoresUseCase: GetStoresUseCase,
        getStoreInfoUseCase: GetStoreInfoUseCase
    ) {
        self.dependency = dependency
        self.fetchStoresUseCase = fetchStoresUseCase
        self.getStoresUseCase = getStoresUseCase
        self.getStoreInfoUseCase = getStoreInfoUseCase
    }
    
    func refresh(
        northWestLocation: Location,
        southEastLocation: Location,
        types: [CertificationType] = [.goodPrice, .exemplary, .safe]
    ) {
        fetchStoresUseCase.execute(northWestLocation: northWestLocation, southEastLocation: southEastLocation)
            .subscribe(onNext: { [weak self] _ in
                self?.applyFilter(types: types)
            })
            .disposed(by: disposeBag)
    }
    
    func applyFilter(types: [CertificationType]) {
        refreshComplete.accept(
            LoadedStores(
                types: types,
                stores: getStoresUseCase.execute(types: types)
            )
        )
    }
    
    func markerTapped(tag: UInt) {
        getStoreInfoComplete.accept(
            getStoreInfoUseCase.execute(tag: tag)
        )
    }
    
}
