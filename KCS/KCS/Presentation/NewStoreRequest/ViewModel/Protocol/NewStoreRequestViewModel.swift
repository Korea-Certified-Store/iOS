//
//  NewStoreRequestViewModel.swift
//  KCS
//
//  Created by 조성민 on 2/17/24.
//

import RxSwift
import RxRelay

protocol NewStoreRequestViewModel: NewStoreRequestViewModelInput, NewStoreRequestViewModelOutput {
    
    var dependency: NewStoreRequestDependency { get }
    
}

protocol NewStoreRequestViewModelInput {
    
    func action(input: NewStoreRequestViewModelInputCase)
    
}

enum NewStoreRequestViewModelInputCase {
    
    case titleWhileEdit(text: String)
    case titleEndEdit(text: String)
    case addressEndEdit(text: String)
    case detailAddressWhileEdit(text: String)
    case detailAddressEndEdit(text: String)
    case certificationEndEdit(requestNewStoreCertificationIsSelected: RequestNewStoreCertificationIsSelected)
    case completeButtonTapped(storeName: String, address: String, certifications: RequestNewStoreCertificationIsSelected)
    
}

protocol NewStoreRequestViewModelOutput {
    
    var titleWarningOutput: PublishRelay<Void> { get }
    var titleEndEditOutput: PublishRelay<Void> { get }
    var addressWarningOutput: PublishRelay<Void> { get }
    var addressEndEditOutput: PublishRelay<Void> { get }
    var detailAddressWarningOutput: PublishRelay<Void> { get }
    var detailAddressEndEditOutput: PublishRelay<Void> { get }
    var certificationWarningOutput: PublishRelay<Void> { get }
    var certificationEndEditOutput: PublishRelay<Void> { get }
    var completeButtonIsEnabledOutput: PublishRelay<Bool> { get }
    var completePostNewStoreOutput: PublishRelay<Void> { get }
    var errorAlertOutput: PublishRelay<ErrorAlertMessage> { get }
    
}
