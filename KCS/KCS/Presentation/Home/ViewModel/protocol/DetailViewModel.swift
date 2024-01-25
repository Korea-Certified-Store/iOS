//
//  DetailViewModel.swift
//  KCS
//
//  Created by 조성민 on 1/24/24.
//

import Foundation

// TODO: 디자인과 기능 스펙이 정해지면 수정해야 합니다.
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
