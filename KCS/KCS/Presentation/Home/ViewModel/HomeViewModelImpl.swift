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
    private let disposeBag = DisposeBag()
    
    var storesLoaded = PublishRelay<[Store]>()
    
    let dependency: HomeDependency
    
    init(
        dependency: HomeDependency,
        fetchStoresUseCase: FetchStoresUseCase,
        getStoresUseCase: GetStoresUseCase
    ) {
        self.dependency = dependency
        self.fetchStoresUseCase = fetchStoresUseCase
        self.getStoresUseCase = getStoresUseCase
    }
    
    func refresh(
        northWestLocation: Location,
        southEastLocation: Location,
        types: [CertificationType] = [.goodPrice, .exemplary, .safe]
    ) {
        fetchStoresUseCase.execute(northWestLocation: northWestLocation, southEastLocation: southEastLocation)
            .subscribe(onNext: { [weak self] _ in
                types.forEach { [weak self] type in
                    self?.applyFilter(type: type)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func applyFilter(type: CertificationType) {
        storesLoaded.accept(getStoresUseCase.execute(type: type))
    }
    
}
