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
    var needToUpdateOutput = PublishRelay<Void>()
    var noNeedToUpdateOutput = PublishRelay<Void>()
    
    init(checkNetworkStatusUseCase: CheckNetworkStatusUseCase) {
        self.checkNetworkStatusUseCase = checkNetworkStatusUseCase
    }
    
    func input(action: SplashViewModelInputCase) {
        switch action {
        case .checkNetworkInput:
            checkNetworkInput()
        case .checkUpdateInput:
            checkUpdateInput()
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
    
    func checkUpdateInput() {
        if isUpdateAvailable() {
            needToUpdateOutput.accept(())
        } else {
            noNeedToUpdateOutput.accept(())
        }
    }
    
    func isUpdateAvailable() -> Bool {
        guard
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=6476478078"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let results = json["results"] as? [[String: Any]],
            results.count > 0,
            let appStoreVersion = results[0]["version"] as? String
        else { return false }
        if !(version == appStoreVersion) { return true }
        return false
    }
    
}
