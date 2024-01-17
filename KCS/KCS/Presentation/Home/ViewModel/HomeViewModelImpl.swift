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
    let getFilteredStoresUseCase: GetFilteredStoresUseCase
    private let disposeBag = DisposeBag()
    
    var refreshComplete = PublishRelay<[FilteredStores]>()
    
    let dependency: HomeDependency
    
    init(
        dependency: HomeDependency,
        fetchStoresUseCase: FetchStoresUseCase,
        getStoresUseCase: GetFilteredStoresUseCase
    ) {
        self.dependency = dependency
        self.fetchStoresUseCase = fetchStoresUseCase
        self.getFilteredStoresUseCase = getStoresUseCase
    }
    
    func refresh(
        northWestLocation: Location,
        southEastLocation: Location,
        types: [CertificationType] = [.goodPrice, .exemplary, .safe]
    ) {
        fetchStoresUseCase.execute(northWestLocation: northWestLocation, southEastLocation: southEastLocation)
            .subscribe(
                onNext: { [weak self] _ in
                    self?.applyFilter(filters: types)
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
    
}
