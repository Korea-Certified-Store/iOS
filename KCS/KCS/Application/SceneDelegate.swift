//
//  SceneDelegate.swift
//  KCS
//
//  Created by 조성민 on 12/24/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let repository = StoreRepositoryImpl()
        let viewModel  = HomeViewModelImpl(
            dependency: HomeDependency(),
            fetchRefreshStoresUseCase: FetchRefreshStoresUseCaseImpl(repository: repository),
            fetchStoresUseCase: FetchStoresUseCaseImpl(repository: repository),
            getStoreInfoUseCase: GetStoreInfoUseCaseImpl(repository: repository)
        )
        window?.rootViewController = HomeViewController(viewModel: viewModel)
        window?.makeKeyAndVisible()
    }

}

