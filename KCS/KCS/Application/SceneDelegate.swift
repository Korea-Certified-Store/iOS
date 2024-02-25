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
        
        // MARK: Observer
        let summaryViewHeightObserver = PublishRelay<SummaryViewHeightCase>()
        let listCellSelectedObserver = PublishRelay<Int>()
        let searchObserver = PublishRelay<String>()
        let textObserver = PublishRelay<String>()
        let addressObserver = PublishRelay<String>()
        let refreshCameraPositionObserver = PublishRelay<NMFCameraPosition>()
        let endMoveCameraPositionObserver = PublishRelay<NMFCameraPosition>()
        
        // MARK: PersistentStorage
        let storeStorage = StoreStorage()
        let storeIDStorage = StoreIDStorage()
        let imageCache = ImageCache()
        let userDefaults = UserDefaults()
        
        // MARK: API
        let getStoresAPI = StoreAPI(type: .getStores)
        let getImageAPI = StoreAPI(type: .getImage)
        let getSearchStoresAPI = StoreAPI(type: .getSearchStores)
        let getAutoCompletionAPI = StoreAPI(type: .getAutoCompletion)
        let postNewStoreRequestAPI = StoreAPI(type: .postNewStoreRequest)
        let storeUpdateRequestAPI = StoreAPI(type: .storeUpdateRequest)
        
        // MARK: Repository
        let fetchStoresRepository = FetchStoresRepositoryImpl(
            storeStorage: storeStorage,
            storeAPI: getStoresAPI
        )
        let getStoresRepository = GetStoresRepositoryImpl(
            storeStorage: storeStorage
        )
        let fetchSearchStoresRepository = FetchSearchStoresRepositoryImpl(
            storeStorage: storeStorage, 
            storeAPI: getSearchStoresAPI
        )
        let storeUpdateRequestRepository = StoreUpdateRequestRepositoryImpl(
            storeAPI: storeUpdateRequestAPI
        )
        let fetchStoreIDRepository = FetchStoreIDRepositoryImpl(
            storage: storeIDStorage
        )
        let fetchRecentSearchHistoryRepository = FetchRecentSearchHistoryRepositoryImpl(
            userDefaults: userDefaults
        )
        let saveRecentSearchHistoryRepository = SaveRecentSearchHistoryRepositoryImpl(
            userDefaults: userDefaults
        )
        let deleteRecentSearchHistoryRepository = DeleteRecentSearchHistoryRepositoryImpl(
            userDefaults: userDefaults
        )
        let deleteAllHistoryRepository = DeleteAllHistoryRepositoryImpl(
            userDefaults: userDefaults
        )
        let fetchAutoCompletionRepository = FetchAutoCompletionRepositoryImpl(
            storeAPI: getAutoCompletionAPI
        )
        let postNewStoreRepository = PostNewStoreRepositoryImpl(
            storeAPI: postNewStoreRequestAPI
        )
        let imageRepository = ImageRepositoryImpl(
            cache: imageCache,
            storeAPI: getImageAPI
        )
        let networkRepository = NetworkRepositoryImpl()
        
        // MARK: UseCase
        let getStoresUseCase = GetStoresUseCaseImpl(
            repository: fetchStoresRepository
        )
        let getRefreshStoresUseCase = GetRefreshStoresUseCaseImpl(
            repository: getStoresRepository
        )
        let getStoreInformationUseCase = GetStoreInformationUseCaseImpl(
            repository: getStoresRepository
        )
        let getSearchStoresUseCase = GetSearchStoresUseCaseImpl(
            repository: fetchSearchStoresRepository
        )
        let storeUpdateRequestUseCase = StoreUpdateRequestUseCaseImpl(
            repository: storeUpdateRequestRepository
        )
        let fetchStoreIDUseCase = FetchStoreIDUseCaseImpl(
            repository: fetchStoreIDRepository
        )
        let setStoreIDUseCase = SetStoreIDUseCaseImpl(
            storage: storeIDStorage
        )
        let getOpenClosedUseCase = GetOpenClosedUseCaseImpl()
        let fetchImageUseCase = FetchImageUseCaseImpl(
            repository: imageRepository
        )
        let fetchRecentSearchHistoryUseCase = FetchRecentSearchHistoryUseCaseImpl(
            repository: fetchRecentSearchHistoryRepository
        )
        let saveRecentSearchHistoryUseCase = SaveRecentSearchHistoryUseCaseImpl(
            repository: saveRecentSearchHistoryRepository
        )
        let deleteRecentSearchHistoryUseCase = DeleteRecentSearchHistoryUseCaseImpl(
            repository: deleteRecentSearchHistoryRepository
        )
        let deleteAllHistoryUseCase = DeleteAllHistoryUseCaseImpl(
            repository: deleteAllHistoryRepository
        )
        let getAutoCompletionUseCase = GetAutoCompletionUseCaseImpl(
            repository: fetchAutoCompletionRepository
        )
        let postNewStoreUseCase = PostNewStoreUseCaseImpl(
            repository: postNewStoreRepository
        )
        let checkNetworkStatusUseCase = CheckNetworkStatusUseCaseImpl(
            repository: networkRepository
        )
        
        // MARK: Dependency
        let homeDependency = HomeDependency(
            getStoresUseCase: getStoresUseCase,
            getRefreshStoresUseCase: getRefreshStoresUseCase,
            getStoreInformationUseCase: getStoreInformationUseCase,
            getSearchStoresUseCase: getSearchStoresUseCase
        )
        let storeUpdateRequestDepenency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: storeUpdateRequestUseCase,
            fetchStoreIDUseCase: fetchStoreIDUseCase,
            setStoreIDUseCase: setStoreIDUseCase
        )
        let storeInformationDependency = StoreInformationDependency(
            getOpenClosedUseCase: getOpenClosedUseCase,
            fetchImageUseCase: fetchImageUseCase
        )
        let searchDependency = SearchDependency(
            fetchRecentSearchHistoryUseCase: fetchRecentSearchHistoryUseCase,
            saveRecentSearchHistoryUseCase: saveRecentSearchHistoryUseCase,
            deleteRecentSearchHistoryUseCase: deleteRecentSearchHistoryUseCase,
            deleteAllHistoryUseCase: deleteAllHistoryUseCase,
            getAutoCompletionUseCase: getAutoCompletionUseCase
        )
        let newStoreRequestDependency = NewStoreRequestDependency(
            postNewStoreUseCase: postNewStoreUseCase
        )
        let storeListDependency = StoreListDependency(
            fetchImageUseCase: fetchImageUseCase
        )
        let splashDependency = SplashDependency(
            checkNetworkStatusUseCase: checkNetworkStatusUseCase
        )

        // MARK: ViewModel
        let homeViewModel = HomeViewModelImpl(
            dependency: homeDependency
        )
        let storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(
            dependency: storeUpdateRequestDepenency
        )
        let storeInformationViewModel = StoreInformationViewModelImpl(
            dependency: storeInformationDependency
        )
        let searchViewModel = SearchViewModelImpl(
            dependency: searchDependency
        )
        let newStoreRequestViewModel = NewStoreRequestViewModelImpl(
            dependency: newStoreRequestDependency
        )
        let storeListViewModel = StoreListViewModelImpl(
            dependency: storeListDependency
        )
        let splashViewModel = SplashViewModelImpl(
            dependency: splashDependency
        )
        
        // MARK: ViewController
        let storeUpdateRequestViewController = StoreUpdateRequestViewController(
            viewModel: storeUpdateRequestViewModel
        )
        let storeInformationViewController = StoreInformationViewController(
            storeUpdateRequestViewController: storeUpdateRequestViewController, 
            summaryViewHeightObserver: summaryViewHeightObserver,
            viewModel: storeInformationViewModel
        )
        let searchViewController = SearchViewController(
            viewModel: searchViewModel,
            searchObserver: searchObserver,
            textObserver: textObserver
        )
        let newStoreRequestViewController = NewStoreRequestViewController(
            viewModel: newStoreRequestViewModel,
            addressObserver: addressObserver
        )
        let storeListViewController = StoreListViewController(
            viewModel: storeListViewModel,
            listCellSelectedObserver: listCellSelectedObserver
        )
        let homeViewController = HomeViewController(
            viewModel: homeViewModel,
            storeListViewController: storeListViewController,
            storeInformationViewController: storeInformationViewController,
            searchViewController: searchViewController,
            newStoreRequestViewController: newStoreRequestViewController,
            summaryViewHeightObserver: summaryViewHeightObserver,
            listCellSelectedObserver: listCellSelectedObserver,
            searchObserver: searchObserver, 
            refreshCameraPositionObserver: refreshCameraPositionObserver,
            endMoveCameraPositionObserver: endMoveCameraPositionObserver
        )
        let onboardingViewController = OnboardingViewController(
            homeViewController: homeViewController
        )
        var splashViewController: SplashViewController
        
        if OnboardStorage.isOnboarded() {
            splashViewController = SplashViewController(
                viewModel: splashViewModel,
                rootViewController: onboardingViewController
            )
        } else {
            splashViewController = SplashViewController(
                viewModel: splashViewModel,
                rootViewController: homeViewController
            )
        }
        
        // MARK: Setting
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = splashViewController
        window?.makeKeyAndVisible()
    }
    
}
