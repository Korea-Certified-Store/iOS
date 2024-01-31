//
//  StoreListViewModel.swift
//  KCS
//
//  Created by 조성민 on 1/31/24.
//

import Foundation

protocol StoreListViewModel: StoreListViewModelInput, StoreListViewModelOutput {
    
}

protocol StoreListViewModelInput {
    
    func action(input: StoreListViewModelInputCase)
    
}

enum StoreListViewModelInputCase {
    
}

protocol StoreListViewModelOutput {
    
}
