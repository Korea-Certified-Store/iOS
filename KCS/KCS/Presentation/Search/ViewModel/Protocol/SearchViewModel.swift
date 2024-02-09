//
//  SearchViewModel.swift
//  KCS
//
//  Created by 조성민 on 2/8/24.
//

import RxRelay

protocol SearchViewModel: SearchViewModelInput, SearchViewModelOutput {
    
}

protocol SearchViewModelInput {
    
    func action(input: SearchViewModelInputCase)
    
}

enum SearchViewModelInputCase {
    
    case textChanged(text: String)
    
}

protocol SearchViewModelOutput {
    
    var generateDataOutput: PublishRelay<[String]> { get }
    
}
