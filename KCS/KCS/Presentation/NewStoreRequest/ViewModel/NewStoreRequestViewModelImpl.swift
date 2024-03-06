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
    let titleEndEditOutput = PublishRelay<Void>()
    let addressWarningOutput = PublishRelay<Void>()
    let addressEndEditOutput = PublishRelay<Void>()
    let detailAddressWarningOutput = PublishRelay<Void>()
    let detailAddressEndEditOutput = PublishRelay<Void>()
    let certificationWarningOutput = PublishRelay<Void>()
    let certificationEndEditOutput = PublishRelay<Void>()
    let completeButtonIsEnabledOutput = PublishRelay<Bool>()
    let completePostNewStoreOutput = PublishRelay<Void>()
    let errorAlertOutput = PublishRelay<ErrorAlertMessage>()
    
    private let disposeBag = DisposeBag()
    private let titleEditState = PublishRelay<Bool>()
    private let addressEditState = PublishRelay<Bool>()
    private let detailAddressEditState = PublishRelay<Bool>()
    private let certificationEditState = PublishRelay<Bool>()
    
    init(dependency: NewStoreRequestDependency) {
        self.dependency = dependency
        checkEditDone()
    }
    
    func action(input: NewStoreRequestViewModelInputCase) {
        switch input {
        case .whileEdit(let text, let inputCase):
            whileEdit(text: text, inputCase: inputCase)
        case .endEdit(let text, let inputCase):
            editEnd(text: text, inputCase: inputCase)
        case .certificationEndEdit(let requestNewStoreCertificationIsSelected):
            certificationEditEnd(requestNewStoreCertificationIsSelected: requestNewStoreCertificationIsSelected)
        case .completeButtonTapped(let storeName, let address, let certifications):
            completeButtonTapped(storeName: storeName, address: address, certifications: certifications)
        }
    }
    
}

private extension NewStoreRequestViewModelImpl {
    
    func whileEdit(text: String, inputCase: InputCase) {
        if text.isEmpty {
            switch inputCase {
            case .title:
                titleEditState.accept(false)
            case .detailAddress:
                detailAddressEditState.accept(false)
            default:
                break
            }
        } else {
            switch inputCase {
            case .title:
                titleEditState.accept(true)
            case .detailAddress:
                detailAddressEditState.accept(true)
            default:
                break
            }
        }
    }
    
    func editEnd(text: String, inputCase: InputCase) {
        if text.isEmpty {
            switch inputCase {
            case .title:
                titleWarningOutput.accept(())
            case .address:
                addressWarningOutput.accept(())
                addressEditState.accept(false)
            case .detailAddress:
                detailAddressWarningOutput.accept(())
            }
        } else {
            switch inputCase {
            case .title:
                titleEndEditOutput.accept(())
            case .address:
                addressEndEditOutput.accept(())
                addressEditState.accept(true)
            case .detailAddress:
                detailAddressEndEditOutput.accept(())
            }
        }
    }
    
    func certificationEditEnd(requestNewStoreCertificationIsSelected: RequestNewStoreCertificationIsSelected) {
        if requestNewStoreCertificationIsSelected.goodPrice == true || 
            requestNewStoreCertificationIsSelected.exemplary == true ||
            requestNewStoreCertificationIsSelected.safe == true {
            certificationEndEditOutput.accept(())
            certificationEditState.accept(true)
        } else {
            certificationWarningOutput.accept(())
            certificationEditState.accept(false)
        }
    }
    
    func completeButtonTapped(storeName: String, address: String, certifications: RequestNewStoreCertificationIsSelected) {
        dependency.postNewStoreUseCase.execute(storeName: storeName, formattedAddress: address, certifications: certifications.toArray())
            .subscribe { [weak self] in
                self?.completePostNewStoreOutput.accept(())
            } onError: { [weak self] error in
                if let error = error as? ErrorAlertMessage {
                    self?.errorAlertOutput.accept(error)
                } else {
                    self?.errorAlertOutput.accept(.client)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func checkEditDone() {
        Observable.combineLatest(
            titleEditState,
            addressEditState,
            detailAddressEditState,
            certificationEditState)
        .compactMap { title, address, detailAddress, certification in
                return title && address && detailAddress && certification
        }
        .bind { [weak self] result in
            self?.completeButtonIsEnabledOutput.accept(result)
        }
        .disposed(by: disposeBag)
    }
    
}
