//
//  SceneDelegate.swift
//  KCS
//
//  Created by 조성민 on 12/24/23.
//

import UIKit
import RxRelay
import NMapsMap

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let storeStorage = StoreStorage()
        let viewModel  = HomeViewModelImpl(
            dependency: HomeDependency(
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
        )
        let storeIDStorage = StoreIDStorage()
        let storeUpdateRequestViewController = StoreUpdateRequestViewController(
            viewModel: StoreUpdateRequestViewModelImpl(
                dependency: StoreUpdateRequestDepenency(
                    storeUpdateRequestUseCase: StoreUpdateRequestUseCaseImpl(
                        repository: StoreUpdateRequestRepositoryImpl()
                    ), fetchStoreIDUseCase: FetchStoreIDUseCaseImpl(
                        repository: FetchStoreIDRepositoryImpl(storage: storeIDStorage)
                    ), setStoreIDUseCase: SetStoreIDUseCaseImpl(
                        storage: storeIDStorage
                    )
                )
            )
        )
        
        let summaryViewHeightObserver = PublishRelay<SummaryViewHeightCase>()
        let listCellSelectedObserver = PublishRelay<Int>()
        let searchObserver = PublishRelay<String>()
        let textObserver = PublishRelay<String>()
        let addressObserver = PublishRelay<String>()
        let refreshCameraPositionObserver = BehaviorRelay<NMFCameraPosition>(value: NMFCameraPosition())
        let searchKeywordRepository = SearchKeywordRepositoryImpl(
            userDefaults: UserDefaults()
        )
        let storeInformationViewController = StoreInformationViewController(
            storeUpdateRequestViewController: storeUpdateRequestViewController, summaryViewHeightObserver: summaryViewHeightObserver,
            viewModel: StoreInformationViewModelImpl(
                dependency: StoreInformationDependency(
                    getOpenClosedUseCase: GetOpenClosedUseCaseImpl(),
                    fetchImageUseCase: FetchImageUseCaseImpl(
                        repository: ImageRepositoryImpl(cache: ImageCache())
                    )
                )
            )
        )
        let searchViewController = SearchViewController(
            viewModel: SearchViewModelImpl(
                fetchRecentSearchKeywordUseCase: FetchRecentSearchKeywordUseCaseImpl(
                    repository: searchKeywordRepository
                ),
                saveRecentSearchKeywordUseCase: SaveRecentSearchKeywordUseCaseImpl(
                    repository: searchKeywordRepository
                ),
                deleteRecentSearchKeywordUseCase: DeleteRecentSearchKeywordUseCaseImpl(
                    repository: searchKeywordRepository
                ),
                deleteAllHistoryUseCase: DeleteAllHistoryUseCaseImpl(
                    repository: searchKeywordRepository
                ),
                getAutoCompletionUseCase: GetAutoCompletionUseCaseImpl(
                    repository: FetchAutoCompletionRepositoryImpl()
                )
            ),
            searchObserver: searchObserver,
            textObserver: textObserver
        )
        let newStoreRequestViewController = NewStoreRequestViewController(
            viewModel: NewStoreRequestViewModelImpl(
                dependency: NewStoreRequestDependency(
                    postNewStoreUseCase: PostNewStoreUseCaseImpl(
                        repository: PostNewStoreRepositoryImpl()
                    )
                )
            ),
            addressObserver: addressObserver
        )
        let homeViewController = HomeViewController(
            viewModel: viewModel,
            storeListViewController: StoreListViewController(
                viewModel: StoreListViewModelImpl(
                    dependency: StoreListDependency(
                        fetchImageUseCase: FetchImageUseCaseImpl(
                            repository: ImageRepositoryImpl(cache: ImageCache())
                        )
                    )
                ),
                listCellSelectedObserver: listCellSelectedObserver
            ),
            storeInformationViewController: storeInformationViewController,
            searchViewController: searchViewController,
            newStoreRequestViewController: newStoreRequestViewController,
            summaryViewHeightObserver: summaryViewHeightObserver,
            listCellSelectedObserver: listCellSelectedObserver,
            searchObserver: searchObserver, 
            refreshCameraPositionObserver: refreshCameraPositionObserver
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

