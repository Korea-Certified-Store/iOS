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
    
    case titleEditEnd(text: String)
    case addressEditEnd(text: String)
    case detailAddressEditEnd(text: String)
    case certificationEditEnd(requestNewStoreCertificationIsSelected: RequestNewStoreCertificationIsSelected)
    case completeButtonTapped(storeName: String, address: String, certifications: RequestNewStoreCertificationIsSelected)
    
}

protocol NewStoreRequestViewModelOutput {
    
    var titleWarningOutput: PublishRelay<Void> { get }
    var titleEditEndOutput: PublishRelay<Void> { get }
    var addressWarningOutput: PublishRelay<Void> { get }
    var addressEditEndOutput: PublishRelay<Void> { get }
    var detailAddressWarningOutput: PublishRelay<Void> { get }
    var detailAddressEditEndOutput: PublishRelay<Void> { get }
    var certificationWarningOutput: PublishRelay<Void> { get }
    var certificationEditEndOutput: PublishRelay<Void> { get }
    var completeButtonIsEnabledOutput: PublishRelay<Bool> { get }
    var completePostNewStoreOutput: PublishRelay<Void> { get }
    var errorAlertOutput: PublishRelay<ErrorAlertMessage> { get }
    
}
