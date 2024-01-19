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

protocol SummaryInformationViewModelInput {
    
    func setOpenClosed(
        openingHour: [RegularOpeningHours]
    )
    
    func setOpeningHour(
        openingHour: [RegularOpeningHours]
    )
    
    func fetchThumbnailImage(
        url: String
    )
    
}

protocol SummaryInformationViewModelOutput {
    
    var openingHourOutput: PublishRelay<String> { get }
    var openClosedOutput: PublishRelay<OpenClosedType> { get }
    var thumbnailImageOutput: PublishRelay<Data> { get }
    
}
