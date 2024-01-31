//
//  StoreTableViewCellViewModel.swift
//  KCS
//
//  Created by 조성민 on 2/1/24.
//

import RxRelay

protocol StoreTableViewCellViewModel: StoreTableViewCellViewModelInput, StoreTableViewCellViewModelOutput {
    
}

protocol StoreTableViewCellViewModelInput {
    
    func action(input: StoreTableViewCellViewModelInputCase)
    
}

enum StoreTableViewCellViewModelInputCase {
    
}

protocol StoreTableViewCellViewModelOutput {
    
}
