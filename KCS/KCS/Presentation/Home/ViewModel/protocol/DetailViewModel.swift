//
//  DetailViewModel.swift
//  KCS
//
//  Created by 조성민 on 1/24/24.
//

import Foundation

protocol DetailViewModel: DetailViewModelInput, DetailViewModelOutput {
    
    init()
    
}

enum DetailViewModelInputCase {
    
}

protocol DetailViewModelInput {
    
    func action(input: DetailViewModelInputCase)
    
}

protocol DetailViewModelOutput {
    
}
