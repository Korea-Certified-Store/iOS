//
//  StoreListViewModel.swift
//  KCS
//
//  Created by 조성민 on 1/31/24.
//

import RxRelay

protocol StoreListViewModel: StoreListViewModelInput, StoreListViewModelOutput {
    
    var fetchImageUseCase: FetchImageUseCase { get }
    
}

protocol StoreListViewModelInput {
    
    func action(input: StoreListViewModelInputCase)
    
}

enum StoreListViewModelInputCase {
    
    case updateList(stores: [Store])
    
}

protocol StoreListViewModelOutput {
    
    var updateListOutput: BehaviorRelay<[StoreTableViewCellContents]> { get }
    
}
