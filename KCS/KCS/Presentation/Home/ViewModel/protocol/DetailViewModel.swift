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
    
    case setImageView(url: String?)
    
    case setOpeningHour(openingHour: [RegularOpeningHours])
}

protocol DetailViewModelInput {
    
    func action(input: DetailViewModelInputCase)
    
}

protocol DetailViewModelOutput {
    var openClosedOutput: PublishRelay<OpeningHourInformation> { get }
    var thumbnailImageOutput: PublishRelay<Data> { get }
}
