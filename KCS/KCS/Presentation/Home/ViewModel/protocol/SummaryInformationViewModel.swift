//
//  SummaryInformationViewModel.swift
//  KCS
//
//  Created by 김영현 on 1/18/24.
//

import RxSwift
import RxRelay

protocol SummaryInformationViewModel: SummaryInformationViewModelInput, SummaryInformationViewModelOutput {
    
    var getOpenClosedUseCase: GetOpenClosedUseCase { get }
    var fetchImageUseCase: FetchImageUseCase { get }
    
}

enum SummaryInformationViewInputCase {
    
    case setOpenClosed(
        openingHour: [RegularOpeningHours]
    )
    case setOpeningHour(
        openingHour: [RegularOpeningHours]
    )
    case fetchThumbnailImage(
        url: String
    )
    
}

protocol SummaryInformationViewModelInput {
    
    func action(input: SummaryInformationViewInputCase)
    
}

protocol SummaryInformationViewModelOutput {
    
    var openingHourOutput: PublishRelay<String> { get }
    var openClosedOutput: PublishRelay<OpenClosedType> { get }
    var thumbnailImageOutput: PublishRelay<Data> { get }
    
}
