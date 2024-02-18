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
    let contentErasePlaceHolder = PublishRelay<Void>()
    let contentFillPlaceHolder = PublishRelay<Void>()
    let contentLengthWarningOutput = PublishRelay<Void>()
    let contentLengthNormalOutput = PublishRelay<Void>()
    let completeButtonIsEnabledOutput = PublishRelay<Bool>()
    
    func action(input: StoreUpdateRequestViewModelInputCase) {
        switch input {
        case .typeInput(let text):
            typeInput(text: text)
        case .contentEndEditing(let text):
            contentEndEditing(text: text)
        case .contentWhileEditing(text: let text):
            contentWhileEditing(text: text)
        case .completeButtonIsEnable(let type, let content):
            completeButtonIsEnable(type: type, content: content)
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
    
    func contentEndEditing(text: String) {
        if text.isEmpty || text.count > 300 {
            contentWarningOutput.accept(())
            contentLengthWarningOutput.accept(())
        } else {
            contentEditEndOutput.accept(())
            contentLengthNormalOutput.accept(())
        }
    }
    
    func contentWhileEditing(text: String) {
        if text.isEmpty {
            contentFillPlaceHolder.accept(())
        } else {
            contentErasePlaceHolder.accept(())
        }
        if text.isEmpty || text.count > 300 {
            contentLengthWarningOutput.accept(())
        } else {
            contentLengthNormalOutput.accept(())
        }
    }
    
    func completeButtonIsEnable(type: String, content: String) {
        if type.isEmpty || content.isEmpty {
            completeButtonIsEnabledOutput.accept(false)
        } else {
            completeButtonIsEnabledOutput.accept(true)
        }
    }
    
}
