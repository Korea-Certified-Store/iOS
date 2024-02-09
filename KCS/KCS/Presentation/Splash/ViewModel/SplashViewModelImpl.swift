//
//  SplashViewModelImpl.swift
//  KCS
//
//  Created by 김영현 on 2/8/24.
//

import RxRelay

final class SplashViewModelImpl: SplashViewModel {
    
    let checkNetworkStatusUseCase: CheckNetworkStatusUseCase
    
    let networkEnableOutput = PublishRelay<Void>()
    let networkDisableOutput = PublishRelay<Void>()
    
    init(checkNetworkStatusUseCase: CheckNetworkStatusUseCase) {
        self.checkNetworkStatusUseCase = checkNetworkStatusUseCase
    }
    
    func input(action: SplashViewModelInputCase) {
        switch action {
        case .checkNetworkInput:
            checkNetworkInput()
        }
    }
    
}

private extension SplashViewModelImpl {
    
    func checkNetworkInput() {
        if checkNetworkStatusUseCase.execute() {
            networkEnableOutput.accept(())
        } else {
            networkDisableOutput.accept(())
        }
    }
    
}
