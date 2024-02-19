//
//  NewStoreRequestViewModelImpl.swift
//  KCS
//
//  Created by 조성민 on 2/17/24.
//

import RxSwift
import RxRelay

final class NewStoreRequestViewModelImpl: NewStoreRequestViewModel {
    
    let dependency: NewStoreRequestDependency
    
    let titleWarningOutput = PublishRelay<Void>()
    let titleEditEndOutput = PublishRelay<Void>()
    let addressWarningOutput = PublishRelay<Void>()
    let addressEditEndOutput = PublishRelay<Void>()
    let detailAddressWarningOutput = PublishRelay<Void>()
    let detailAddressEditEndOutput = PublishRelay<Void>()
    let certificationWarningOutput = PublishRelay<Void>()
    let certificationEditEndOutput = PublishRelay<Void>()
    let completeButtonIsEnabledOutput = PublishRelay<Bool>()
    let completePostNewStoreOutput = PublishRelay<Void>()
    let errorAlertOutput = PublishRelay<ErrorAlertMessage>()
    
    init(dependency: NewStoreRequestDependency) {
        self.dependency = dependency
        checkEditDone()
    }
    
    func action(input: NewStoreRequestViewModelInputCase) {
        switch input {
        case .titleEditEnd(let text):
            editEnd(text: text, inputCase: .title)
        case .addressEditEnd(let text):
            editEnd(text: text, inputCase: .address)
        case .detailAddressEditEnd(let text):
            editEnd(text: text, inputCase: .detailAddress)
        case .certificationEditEnd(let requestNewStoreCertificationIsSelected):
            certificationEditEnd(requestNewStoreCertificationIsSelected: requestNewStoreCertificationIsSelected)
        case .completeButtonTapped(let storeName, let address, let certifications):
            completeButtonTapped(storeName: storeName, address: address, certifications: certifications)
        }
    }
    
}

private extension NewStoreRequestViewModelImpl {
    
    enum InputCase {
        case title
        case address
        case detailAddress
    }
    
    func editEnd(text: String, inputCase: InputCase) {
        if text.isEmpty {
            switch inputCase {
            case .title:
                titleWarningOutput.accept(())
                dependency.titleEditState.accept(false)
            case .address:
                addressWarningOutput.accept(())
                dependency.addressEditState.accept(false)
            case .detailAddress:
                detailAddressWarningOutput.accept(())
                dependency.detailAddressEditState.accept(false)
            }
        } else {
            switch inputCase {
            case .title:
                titleEditEndOutput.accept(())
                dependency.titleEditState.accept(true)
            case .address:
                addressEditEndOutput.accept(())
                dependency.addressEditState.accept(true)
            case .detailAddress:
                detailAddressEditEndOutput.accept(())
                dependency.detailAddressEditState.accept(true)
            }
        }
    }
    
    func certificationEditEnd(requestNewStoreCertificationIsSelected: RequestNewStoreCertificationIsSelected) {
        if requestNewStoreCertificationIsSelected.goodPrice == true || 
            requestNewStoreCertificationIsSelected.exemplary == true ||
            requestNewStoreCertificationIsSelected.safe == true {
            certificationEditEndOutput.accept(())
            dependency.certificationEditState.accept(true)
        } else {
            certificationWarningOutput.accept(())
            dependency.certificationEditState.accept(false)
        }
    }
    
    func completeButtonTapped(storeName: String, address: String, certifications: RequestNewStoreCertificationIsSelected) {
        dependency.postNewStoreUseCase.execute(storeName: storeName, formattedAddress: address, certifications: certifications.toArray())
            .subscribe { [weak self] in
                self?.completePostNewStoreOutput.accept(())
            } onError: { [weak self] error in
                guard let error = error as? ErrorAlertMessage else { return }
                self?.errorAlertOutput.accept(error)
            }
            .disposed(by: dependency.disposeBag)
    }
    
    func checkEditDone() {
        Observable.combineLatest(
            dependency.titleEditState,
            dependency.addressEditState,
            dependency.detailAddressEditState,
            dependency.certificationEditState)
        .compactMap { title, address, detailAddress, certification in
                return title && address && detailAddress && certification
        }
        .bind { [weak self] result in
            self?.completeButtonIsEnabledOutput.accept(result)
        }
        .disposed(by: dependency.disposeBag)
    }
    
}
