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
        
        let summaryViewHeightObserver = PublishRelay<SummaryViewHeightCase>()
        let listCellSelectedObserver = PublishRelay<Int>()
        let searchObserver = PublishRelay<String>()
        let textObserver = PublishRelay<String>()
        let addressObserver = PublishRelay<String>()
        let refreshCameraPositionObserver = PublishRelay<NMFCameraPosition>()
        let endMoveCameraPositionObserver = PublishRelay<NMFCameraPosition>()
        
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
        let fetchRecentSearchKeywordUseCase = FetchRecentSearchKeywordUseCaseImpl(
            repository: searchKeywordRepository
        )
        let saveRecentSearchKeywordUseCase = SaveRecentSearchKeywordUseCaseImpl(
            repository: searchKeywordRepository
        )
        let deleteRecentSearchKeywordUseCase = DeleteRecentSearchKeywordUseCaseImpl(
            repository: searchKeywordRepository
        )
        let deleteAllHistoryUseCase = DeleteAllHistoryUseCaseImpl(
            repository: searchKeywordRepository
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
            fetchRecentSearchKeywordUseCase: fetchRecentSearchKeywordUseCase,
            saveRecentSearchKeywordUseCase: saveRecentSearchKeywordUseCase,
            deleteRecentSearchKeywordUseCase: deleteRecentSearchKeywordUseCase,
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
        
        window?.rootViewController = splashViewController
        window?.makeKeyAndVisible()
    }
    
}

