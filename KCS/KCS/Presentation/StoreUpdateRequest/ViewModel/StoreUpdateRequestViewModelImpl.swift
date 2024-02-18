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
        case .postUpdateRequest(let type, let content):
            postUpdateRequest(type: type, content: content)
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
        if type.isEmpty || content.isEmpty {
            completeButtonIsEnabledOutput.accept(false)
        } else {
            completeButtonIsEnabledOutput.accept(true)
        }
    }
    
    func postUpdateRequest(type: String, content: String) {
        let type = type == "수정" ? "fix" : "del"
        // TODO: StoreID를 지니고 있고, 그걸 아래에 넣어줘야 함.
        guard let storeID = dependency.fetchStoreIDUseCase.execute() else {
            // TODO: 에러 알러트 보내는 output
            return
        }
        dependency.postUpdateRequestUseCase.execute(
            type: type, storeID: storeID, content: content
        )
        .subscribe(
            onNext: { [weak self] in
                // TODO: 완료 알러트 보내는 output
                print("완료")
            },
            onError: { [weak self] error in
                // TODO: 에러 알러트 보내는 output
                print(error)
            }
        )
        .disposed(by: dependency.disposeBag)
    }
    
}
