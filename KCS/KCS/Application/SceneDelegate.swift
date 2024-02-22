//
//  SceneDelegate.swift
//  KCS
//
//  Created by 조성민 on 12/24/23.
//

import UIKit
import RxRelay
import NMapsMap

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let storeStorage = StoreStorage()
        let storeIDStorage = StoreIDStorage()
        let imageCache = ImageCache()
        let userDefaults = UserDefaults()
        
        let fetchStoresRepository = FetchStoresRepositoryImpl(
            storeStorage: storeStorage
        )
        let getStoresRepository = GetStoresRepositoryImpl(
            storeStorage: storeStorage
        )
        let fetchSearchStoresRepository = FetchSearchStoresRepositoryImpl(
            storeStorage: storeStorage
        )
        let storeUpdateRequestRepository = StoreUpdateRequestRepositoryImpl()
        
        let fetchStoreIDRepository = FetchStoreIDRepositoryImpl(
            storage: storeIDStorage
        )
        let searchKeywordRepository = SearchKeywordRepositoryImpl(
            userDefaults: userDefaults
        )
        let fetchAutoCompletionRepository = FetchAutoCompletionRepositoryImpl()
        let postNewStoreRepository = PostNewStoreRepositoryImpl()
        let imageRepository = ImageRepositoryImpl(cache: imageCache)
        let networkRepository = NetworkRepositoryImpl()
        
        let homeDependency = HomeDependency(
            getStoresUseCase: GetStoresUseCaseImpl(
                repository: fetchStoresRepository
            ),
            getRefreshStoresUseCase: GetRefreshStoresUseCaseImpl(
                repository: getStoresRepository
            ),
            getStoreInformationUseCase: GetStoreInformationUseCaseImpl(
                repository: getStoresRepository
            ),
            getSearchStoresUseCase: GetSearchStoresUseCaseImpl(
                repository: fetchSearchStoresRepository
            )
        )
        
        let homeViewModel  = HomeViewModelImpl(
            dependency: homeDependency
        )
        
        let storeUpdateRequestViewController = StoreUpdateRequestViewController(
            viewModel: StoreUpdateRequestViewModelImpl(
                dependency: StoreUpdateRequestDepenency(
                    storeUpdateRequestUseCase: StoreUpdateRequestUseCaseImpl(
                        repository: storeUpdateRequestRepository
                    ),
                    fetchStoreIDUseCase: FetchStoreIDUseCaseImpl(
                        repository: fetchStoreIDRepository
                    ),
                    setStoreIDUseCase: SetStoreIDUseCaseImpl(
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
        let refreshCameraPositionObserver = PublishRelay<NMFCameraPosition>()
        let endMoveCameraPositionObserver = PublishRelay<NMFCameraPosition>()
        
        let storeInformationViewController = StoreInformationViewController(
            storeUpdateRequestViewController: storeUpdateRequestViewController, 
            summaryViewHeightObserver: summaryViewHeightObserver,
            viewModel: StoreInformationViewModelImpl(
                dependency: StoreInformationDependency(
                    getOpenClosedUseCase: GetOpenClosedUseCaseImpl(),
                    fetchImageUseCase: FetchImageUseCaseImpl(
                        repository: ImageRepositoryImpl(cache: imageCache)
                    )
                )
            )
        )
        let searchViewController = SearchViewController(
            viewModel: SearchViewModelImpl(
                dependency: SearchDependency(
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
                        repository: fetchAutoCompletionRepository
                    )
                )
            ),
            searchObserver: searchObserver,
            textObserver: textObserver
        )
        let newStoreRequestViewController = NewStoreRequestViewController(
            viewModel: NewStoreRequestViewModelImpl(
                dependency: NewStoreRequestDependency(
                    postNewStoreUseCase: PostNewStoreUseCaseImpl(
                        repository: postNewStoreRepository
                    )
                )
            ),
            addressObserver: addressObserver
        )
        let homeViewController = HomeViewController(
            viewModel: homeViewModel,
            storeListViewController: StoreListViewController(
                viewModel: StoreListViewModelImpl(
                    dependency: StoreListDependency(
                        fetchImageUseCase: FetchImageUseCaseImpl(
                            repository: imageRepository
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
            refreshCameraPositionObserver: refreshCameraPositionObserver,
            endMoveCameraPositionObserver: endMoveCameraPositionObserver
        )
        
        var rootViewController: UIViewController
        
        if OnboardStorage.isOnboarded() {
            rootViewController = OnboardingViewController(homeViewController: homeViewController)
        } else {
            rootViewController = homeViewController
        }
        
        let splashViewController = SplashViewController(
            viewModel: SplashViewModelImpl(
                dependency: SplashDependency(
                    checkNetworkStatusUseCase: CheckNetworkStatusUseCaseImpl(
                        repository: networkRepository
                    )
                )
            ), rootViewController: rootViewController
        )
        
        window?.rootViewController = splashViewController
        window?.makeKeyAndVisible()
    }
    
}

