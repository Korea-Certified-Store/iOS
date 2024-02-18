//
//  NewStoreRequestViewModelImpl.swift
//  KCS
//
//  Created by 조성민 on 2/17/24.
//

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
            case .address:
                addressWarningOutput.accept(())
            case .detailAddress:
                detailAddressWarningOutput.accept(())
            }
        } else {
            switch inputCase {
            case .title:
                titleEditEndOutput.accept(())
            case .address:
                addressEditEndOutput.accept(())
            case .detailAddress:
                detailAddressEditEndOutput.accept(())
            }
        }
    }
    
    func certificationEditEnd(requestNewStoreCertificationIsSelected: RequestNewStoreCertificationIsSelected) {
        if requestNewStoreCertificationIsSelected.goodPrice == true || 
            requestNewStoreCertificationIsSelected.exemplary == true ||
            requestNewStoreCertificationIsSelected.safe == true {
            certificationEditEndOutput.accept(())
        } else {
            certificationWarningOutput.accept(())
        }
    }
    
}
