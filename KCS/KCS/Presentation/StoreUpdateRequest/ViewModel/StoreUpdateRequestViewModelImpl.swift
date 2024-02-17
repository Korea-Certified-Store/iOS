//
//  StoreUpdateRequestViewModelImpl.swift
//  KCS
//
//  Created by 조성민 on 2/17/24.
//

import RxRelay

final class StoreUpdateRequestViewModelImpl: StoreUpdateRequestViewModel {
    
    let typeWarningOutput = PublishRelay<Void>()
    let typeEditEndOutput = PublishRelay<Void>()
    let contentWarningOutput = PublishRelay<Void>()
    let contentEditEndOutput = PublishRelay<Void>()
    
    func action(input: StoreUpdateRequestViewModelInputCase) {
        switch input {
        case .typeInput(let text):
            typeInput(text: text)
        case .contentInput(let text):
            contentInput(text: text)
        }
    }
    
}

private extension StoreUpdateRequestViewModelImpl {
    
    func typeInput(text: String) {
        if text.isEmpty {
            typeWarningOutput.accept(())
        } else {
            typeEditEndOutput.accept(())
        }
    }
    
    func contentInput(text: String) {
        if text.isEmpty {
            contentWarningOutput.accept(())
        } else {
            contentEditEndOutput.accept(())
        }
    }
    
}
