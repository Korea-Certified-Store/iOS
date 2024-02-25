//
//  StoreInformationViewModel.swift
//  KCS
//
//  Created by 조성민 on 2/3/24.
//

import RxRelay

protocol StoreInformationViewModel: StoreInformationViewModelInput, StoreInformationViewModelOutput {
    
    var dependency: StoreInformationDependency { get }
    
}

enum StoreInformationViewModelInputCase {
    
    case setUIContents(store: Store)
    
}

protocol StoreInformationViewModelInput {
    
    func action(input: StoreInformationViewModelInputCase)
    
}

protocol StoreInformationViewModelOutput {
    
    var setDetailUIContentsOutput: PublishRelay<DetailViewContents> { get }
    var openClosedContentOutput: PublishRelay<OpenClosedContent> { get }
    var noneOpenClosedContentOutput: PublishRelay<Void> { get }
    var setSummaryUIContentsOutput: PublishRelay<SummaryViewContents> { get }
    var thumbnailImageOutput: PublishRelay<Data> { get }
    var summaryCallButtonOutput: PublishRelay<String> { get }
    var errorAlertOutput: PublishRelay<ErrorAlertMessage> { get }
    
}
