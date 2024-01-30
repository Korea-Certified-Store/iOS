//
//  DetailViewModel.swift
//  KCS
//
//  Created by 조성민 on 1/24/24.
//

import RxSwift
import RxRelay

protocol DetailViewModel: DetailViewModelInput, DetailViewModelOutput {
    
    var getOpenClosedUseCase: GetOpenClosedUseCase { get }
    var fetchImageUseCase: FetchImageUseCase { get }
    
}

enum DetailViewModelInputCase {
    
    case setUIContents(store: Store)
    
}

protocol DetailViewModelInput {
    
    func action(input: DetailViewModelInputCase)
    
}

protocol DetailViewModelOutput {
    
    var setUIContentsOutput: PublishRelay<DetailViewContents> { get }
    var thumbnailImageOutput: PublishRelay<Data> { get }
    var errorAlertOutput: PublishRelay<ErrorAlertMessage> { get }
    
}
