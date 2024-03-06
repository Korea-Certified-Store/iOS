//
//  StoreUpdateRequestViewModelImpl.swift
//  KCS
//
//  Created by 조성민 on 2/17/24.
//

import RxRelay
import RxSwift

final class StoreUpdateRequestViewModelImpl: StoreUpdateRequestViewModel {
    
    let dependency: StoreUpdateRequestDepenency
    
    let typeWarningOutput = PublishRelay<Void>()
    let typeEditEndOutput = PublishRelay<Void>()
    let contentWarningOutput = PublishRelay<Void>()
    let contentEditEndOutput = PublishRelay<Void>()
    let contentErasePlaceHolder = PublishRelay<Void>()
    let contentFillPlaceHolder = PublishRelay<Void>()
    let contentLengthWarningOutput = PublishRelay<Void>()
    let contentLengthNormalOutput = PublishRelay<Void>()
    let completeButtonIsEnabledOutput = PublishRelay<Bool>()
    let completeRequestOutput = PublishRelay<Void>()
    let errorAlertOutput = PublishRelay<ErrorAlertMessage>()
    
    private let disposeBag = DisposeBag()
    
    init(dependency: StoreUpdateRequestDepenency) {
        self.dependency = dependency
    }
    
    func action(input: StoreUpdateRequestViewModelInputCase) {
        switch input {
        case .setStoreID(let id):
            setStoreID(id: id)
        case .typeInput(let text):
            typeInput(text: text)
        case .contentEndEditing(let text):
            contentEndEditing(text: text)
        case .contentWhileEditing(let text):
            contentWhileEditing(text: text)
        case .completeButtonIsEnable(let type, let content):
            completeButtonIsEnable(type: type, content: content)
        case .storeUpdateRequest(let type, let content):
            storeUpdateRequest(type: type, content: content)
        }
    }
    
}

private extension StoreUpdateRequestViewModelImpl {
    
    func setStoreID(id: Int) {
        dependency.setStoreIDUseCase.execute(id: id)
    }
    
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
        if type.isEmpty || content.isEmpty || content.count > 300 {
            completeButtonIsEnabledOutput.accept(false)
        } else {
            completeButtonIsEnabledOutput.accept(true)
        }
    }
    
    func storeUpdateRequest(type: String, content: String) {
        let type: StoreUpdateRequestType = type == "수정" ? .fix : .delete
        guard let storeID = dependency.fetchStoreIDUseCase.execute() else {
            errorAlertOutput.accept(.client)
            return
        }
        dependency.storeUpdateRequestUseCase.execute(
            type: type, storeID: storeID, content: content
        )
        .subscribe(
            onNext: { [weak self] in
                self?.completeRequestOutput.accept(())
            },
            onError: { [weak self] error in
                if let error = error as? ErrorAlertMessage {
                    self?.errorAlertOutput.accept(error)
                }
            }
        )
        .disposed(by: disposeBag)
    }
    
}
