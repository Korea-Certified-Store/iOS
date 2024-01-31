//
//  StoreListViewModelImpl.swift
//  KCS
//
//  Created by 조성민 on 1/31/24.
//

import RxRelay

final class StoreListViewModelImpl: StoreListViewModel {
    
    let refreshOutput = PublishRelay<[Store]>()
    
    func action(input: StoreListViewModelInputCase) {
        
    }
    
}

private extension StoreListViewModelImpl {
    
}
