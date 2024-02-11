//
//  SceneDelegate.swift
//  KCS
//
//  Created by 조성민 on 12/24/23.
//

import UIKit
import RxRelay

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
            getStoreInformationUseCase: GetStoreInformationUseCaseImpl(repository: repository)
        )
        let summaryViewHeightObserver = PublishRelay<SummaryViewHeightCase>()
        let listCellSelectedObserver = PublishRelay<Int>()
        let storeInformationViewController = StoreInformationViewController(
            summaryViewHeightObserver: summaryViewHeightObserver,
            viewModel: StoreInformationViewModelImpl(
                getOpenClosedUseCase: GetOpenClosedUseCaseImpl(),
                fetchImageUseCase: FetchImageUseCaseImpl(
                    repository: ImageRepositoryImpl(cache: ImageCache())
                )
            )
        )
        let homeViewController = HomeViewController(
            viewModel: viewModel,
            storeInformationViewController: storeInformationViewController,
            storeListViewController: StoreListViewController(
                viewModel: StoreListViewModelImpl(
                    fetchImageUseCase: FetchImageUseCaseImpl(
                        repository: ImageRepositoryImpl(cache: ImageCache())
                    )
                ),
                listCellSelectedObserver: listCellSelectedObserver
            ),
            summaryViewHeightObserver: summaryViewHeightObserver,
            listCellSelectedObserver: listCellSelectedObserver
        )
        
        var rootViewController: UIViewController
        
        if Storage.isOnboarded() {
            rootViewController = OnboardingViewController(homeViewController: homeViewController)
        } else {
            rootViewController = homeViewController
        }
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
}

