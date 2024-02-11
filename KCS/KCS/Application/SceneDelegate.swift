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
        
        let storeStorage = StoreStorage()
        let viewModel  = HomeViewModelImpl(
            dependency: HomeDependency(),
            getStoresUseCase: GetStoresUseCaseImpl(
                repository: FetchStoresRepositoryImpl(
                    storeStorage: storeStorage
                )
            ),
            getRefreshStoresUseCase: GetRefreshStoresUseCaseImpl(
                repository: GetStoresRepositoryImpl(
                    storeStorage: storeStorage
                )
            ),
            getStoreInformationUseCase: GetStoreInformationUseCaseImpl(
                repository: GetStoresRepositoryImpl(
                    storeStorage: storeStorage
                )
            ),
            getSearchStoresUseCase: GetSearchStoresUseCaseImpl(
                repository: FetchSearchStoresRepositoryImpl(
                    storeStorage: storeStorage
                )
            )
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
        let searchObserver = PublishRelay<String>()
        let searchKeywordRepository = SearchKeywordRepositoryImpl(
            userDefaults: UserDefaults()
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
            listCellSelectedObserver: listCellSelectedObserver,
            searchViewController: SearchViewController(
                viewModel: SearchViewModelImpl(
                    fetchRecentSearchKeywordUseCase: FetchRecentSearchKeywordUseCaseImpl(
                        repository: searchKeywordRepository
                    ),
                    saveRecentSearchKeywordUseCase: SaveRecentSearchKeywordUseCaseImpl(
                        repository: searchKeywordRepository
                    ), 
                    deleteRecentSearchKeywordUseCase: DeleteRecentSearchKeywordUseCaseImpl(
                        repository: searchKeywordRepository
                    )
                ),
                searchObserver: searchObserver
            ),
            searchObserver: searchObserver
        )
        
        var rootViewController: UIViewController
        
        if OnboardStorage.isOnboarded() {
            rootViewController = OnboardingViewController(homeViewController: homeViewController)
        } else {
            rootViewController = homeViewController
        }
        
        let splashViewController = SplashViewController(
            viewModel: SplashViewModelImpl(
                checkNetworkStatusUseCase: CheckNetworkStatusUseCaseImpl(
                    repository: NetworkRepositoryImpl()
                )
            ), rootViewController: rootViewController
        )
        
        window?.rootViewController = splashViewController
        window?.makeKeyAndVisible()
    }
    
}

