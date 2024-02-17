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
    
    func action(input: NewStoreRequestViewModelInputCase) {
        switch input {
        case .titleEditEnd(let text):
            titleEditEnd(text: text)
        }
    }
    
}

private extension NewStoreRequestViewModelImpl {
    
    func titleEditEnd(text: String) {
        if text.isEmpty {
            titleWarningOutput.accept(())
        } else {
            titleEditEndOutput.accept(())
        }
    }
    
}
