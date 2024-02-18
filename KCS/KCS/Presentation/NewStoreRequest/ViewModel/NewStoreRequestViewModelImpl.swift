//
//  NewStoreRequestViewModelImpl.swift
//  KCS
//
//  Created by 조성민 on 2/17/24.
//

import RxSwift
import RxRelay

final class NewStoreRequestViewModelImpl: NewStoreRequestViewModel {
    
    let titleWarningOutput = PublishRelay<Void>()
    let titleEditEndOutput = PublishRelay<Void>()
    let addressWarningOutput = PublishRelay<Void>()
    let addressEditEndOutput = PublishRelay<Void>()
    let detailAddressWarningOutput = PublishRelay<Void>()
    let detailAddressEditEndOutput = PublishRelay<Void>()
    let certificationWarningOutput = PublishRelay<Void>()
    let certificationEditEndOutput = PublishRelay<Void>()
    let completeEditOutput = PublishRelay<Void>()
    let noCompleteEditOutput = PublishRelay<Void>()
    
    private let titleEditState = PublishRelay<Bool>()
    private let addressEditState = PublishRelay<Bool>()
    private let detailAddressEditState = PublishRelay<Bool>()
    private let certificationEditState = PublishRelay<Bool>()
    private let disposeBag = DisposeBag()
    
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
                titleEditState.accept(false)
            case .address:
                addressWarningOutput.accept(())
                addressEditState.accept(false)
            case .detailAddress:
                detailAddressWarningOutput.accept(())
                detailAddressEditState.accept(false)
            }
        } else {
            switch inputCase {
            case .title:
                titleEditEndOutput.accept(())
                titleEditState.accept(true)
            case .address:
                addressEditEndOutput.accept(())
                addressEditState.accept(true)
            case .detailAddress:
                detailAddressEditEndOutput.accept(())
                detailAddressEditState.accept(true)
            }
        }
        checkEditDone()
    }
    
    func certificationEditEnd(requestNewStoreCertificationIsSelected: RequestNewStoreCertificationIsSelected) {
        if requestNewStoreCertificationIsSelected.goodPrice == true || 
            requestNewStoreCertificationIsSelected.exemplary == true ||
            requestNewStoreCertificationIsSelected.safe == true {
            certificationEditEndOutput.accept(())
            certificationEditState.accept(true)
        } else {
            certificationWarningOutput.accept(())
            certificationEditState.accept(false)
        }
        checkEditDone()
    }
    
    func checkEditDone() {
        Observable.combineLatest(
            titleEditState,
            addressEditState,
            detailAddressEditState,
            certificationEditState)
        .bind(onNext: { [weak self] title, address, detailAddress, certification in
            if title && address && detailAddress && certification {
                self?.completeEditOutput.accept(())
            } else {
                self?.noCompleteEditOutput.accept(())
            }
        })
        .disposed(by: disposeBag)
    }
    
}
