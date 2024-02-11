//
//  SplashViewModel.swift
//  KCS
//
//  Created by 김영현 on 2/8/24.
//

import RxRelay

protocol SplashViewModel: SplashViewModelInput, SplashViewModelOutput {
    
    var checkNetworkStatusUseCase: CheckNetworkStatusUseCase { get }
    
}

protocol SplashViewModelInput {
    
    func input(action: SplashViewModelInputCase)
    
}

enum SplashViewModelInputCase {
    
    case checkNetworkInput
    case checkUpdateInput
    
}

protocol SplashViewModelOutput {
    
    var networkEnableOutput: PublishRelay<Void> { get }
    var networkDisableOutput: PublishRelay<Void> { get }
    var needToUpdateOutput: PublishRelay<Void> { get }
    var noNeedToUpdateOutput: PublishRelay<Void> { get }
    
}
