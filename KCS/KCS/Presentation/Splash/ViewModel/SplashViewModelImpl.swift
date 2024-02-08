//
//  SplashViewModelImpl.swift
//  KCS
//
//  Created by 김영현 on 2/8/24.
//

import RxRelay

final class SplashViewModelImpl: SplashViewModel {
    
    let checkNetworkStatusUseCase: CheckNetworkStatusUseCase
    
    let networkStatusOutput = PublishRelay<Bool>()
    
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
        networkStatusOutput.accept(checkNetworkStatusUseCase.execute())
    }
    
}
