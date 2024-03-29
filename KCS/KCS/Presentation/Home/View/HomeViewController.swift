//
//  ViewController.swift
//  KCS
//
//  Created by 조성민 on 12/24/23.
//

import UIKit
import NMapsMap
import CoreLocation
import RxSwift
import RxCocoa
import RxGesture

final class HomeViewController: UIViewController {
    
    private lazy var goodPriceFilterButton: FilterButton = {
        let type = CertificationType.goodPrice
        let button = FilterButton(type: type)
        button.translatesAutoresizingMaskIntoConstraints = false
        bindFilterButton(button: button, type: type)
        
        return button
    }()
    
    private lazy var exemplaryFilterButton: FilterButton = {
        let type = CertificationType.exemplary
        let button = FilterButton(type: type)
        button.translatesAutoresizingMaskIntoConstraints = false
        bindFilterButton(button: button, type: type)
        
        return button
    }()
    
    private lazy var safeFilterButton: FilterButton = {
        let type = CertificationType.safe
        let button = FilterButton(type: type)
        button.translatesAutoresizingMaskIntoConstraints = false
        bindFilterButton(button: button, type: type)
        
        return button
    }()
    
    private lazy var filterButtonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [goodPriceFilterButton, exemplaryFilterButton, safeFilterButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        return stack
    }()
    
    private lazy var searchBarView: SearchBarView = {
        let view = SearchBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.searchTextField.delegate = self
        view.layer.borderColor = UIColor.placeholderText.cgColor
        
        view.xMarkImageView.rx
            .tapGesture()
            .when(.ended)
            .throttle(.milliseconds(10), latest: false, scheduler: MainScheduler())
            .map { [weak self] _ -> RequestLocation? in
                guard let self = self else { return nil }
                if view.xMarkImageView.isUserInteractionEnabled == false { return nil }
                disableAllWhileLoading()
                refreshButton.animationFire()
                view.layer.borderWidth = 0
                view.searchTextField.text = ""
                researchKeywordButton.isHidden = true
                refreshButton.isHidden = false
                return makeRequestLocation(projection: mapView.mapView.projection)
            }
            .observe(on: ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()))
            .subscribe(onNext: { [weak self] requestLocation in
                guard let self = self,
                      let location = requestLocation else { return }
                viewModel.action(
                    input: .refresh(
                        requestLocation: location
                    )
                )
                refreshCameraPositionObserver.accept(mapView.mapView.cameraPosition)
            })
            .disposed(by: disposeBag)
        
        Observable.merge(
            view.searchImageView.rx
                .tapGesture()
                .when(.ended),
            view.searchTextField.rx
                .tapGesture()
                .when(.ended)
        )
        .throttle(.milliseconds(10), latest: false, scheduler: MainScheduler())
        .subscribe(onNext: { [weak self] _ in
            if view.searchTextField.isUserInteractionEnabled == false { return }
            self?.disableAllWhileLoading()
            self?.presentSearchViewController()
        })
        .disposed(by: disposeBag)
        
        return view
    }()
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        
        return locationManager
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                disableAllWhileLoading()
                viewModel.action(
                    input: .locationButtonTapped(
                        locationAuthorizationStatus: locationManager.authorizationStatus,
                        positionMode: mapView.mapView.positionMode
                    )
                )
            }
            .disposed(by: self.disposeBag)
        button.setImage(UIImage.locationButtonNone, for: .normal)
        
        return button
    }()
    
    private lazy var mapView: NMFNaverMapView = {
        let map = NMFNaverMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showCompass = false
        map.showZoomControls = false
        map.showScaleBar = false
        map.showIndoorLevelPicker = false
        map.showLocationButton = false
        map.mapView.logoAlign = .rightBottom
        map.mapView.logoMargin = UIEdgeInsets(top: 0, left: 0, bottom: 69, right: 0)
        map.mapView.touchDelegate = self
        map.mapView.addCameraDelegate(delegate: self)
        
        return map
    }()
    
    private lazy var refreshButton: RefreshButton = {
        var attributedString = AttributedString("현 지도에서 검색")
        attributedString.font = UIFont.pretendard(size: 11, weight: .medium)
        
        let button = RefreshButton(attributedTitle: attributedString)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rx.tap
            .throttle(.milliseconds(10), latest: false, scheduler: MainScheduler())
            .map { [weak self] _ -> RequestLocation? in
                guard let self = self else { return nil }
                if button.isUserInteractionEnabled == false { return nil }
                button.animationFire()
                disableAllWhileLoading()
                
                return makeRequestLocation(projection: mapView.mapView.projection)
            }
            .observe(on: ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()))
            .bind { [weak self] requestLocation in
                guard let self = self,
                      let location = requestLocation else { return }
                viewModel.action(
                    input: .refresh(
                        requestLocation: location
                    )
                )
                refreshCameraPositionObserver.accept(mapView.mapView.cameraPosition)
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var moreStoreButton: MoreStoreButton = {
        let button = MoreStoreButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.rx.tap
            .throttle(.milliseconds(10), latest: false, scheduler: MainScheduler())
            .bind { [weak self] in
                if button.isUserInteractionEnabled == false { return }
                self?.disableAllWhileLoading()
                self?.viewModel.action(
                    input: .moreStoreButtonTapped
                )
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var researchKeywordButton: RefreshButton = {
        var titleAttribute = AttributedString("현재 키워드로 재검색")
        titleAttribute.font = UIFont.pretendard(size: 11, weight: .medium)
        
        let button = RefreshButton(attributedTitle: titleAttribute)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.rx.tap
            .throttle(.milliseconds(10), latest: false, scheduler: MainScheduler())
            .bind { [weak self] in
                if button.isUserInteractionEnabled == false { return }
                guard let text = self?.searchBarView.searchTextField.text else { return }
                self?.disableAllWhileLoading()
                button.animationFire()
                self?.searchObserver.accept(text)
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var addStoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.addStoreButton, for: .normal)
        button.setLayerShadow(shadowOffset: CGSize(width: 0, height: 2))
        button.rx.tap
            .throttle(.milliseconds(10), latest: false, scheduler: MainScheduler())
            .bind { [weak self] in
                guard let self = self else { return }
                if addStoreButton.isUserInteractionEnabled == false { return }
                disableAllWhileLoading()
                if let presentController = presentedViewController {
                    presentController.present(newStoreRequeestViewController, animated: true) { [weak self] in
                        self?.enableAllWhileLoading()
                    }
                } else {
                    present(newStoreRequeestViewController, animated: true) { [weak self] in
                        self?.enableAllWhileLoading()
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var backStoreListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.backListButton, for: .normal)
        button.setLayerShadow(shadowOffset: CGSize(width: 0, height: 2))
        button.isHidden = true
        button.rx.tap
            .throttle(.milliseconds(10), latest: false, scheduler: MainScheduler())
            .bind { [weak self] in
                if button.isUserInteractionEnabled == false { return }
                self?.disableAllWhileLoading()
                self?.backStoreListButton.isHidden = true
                self?.searchBarViewLeadingConstraint.constant = 16
                self?.clickedMarker?.deselect()
                self?.clickedMarker = nil
                self?.storeInformationViewController.dismiss(animated: true) { [weak self] in
                    self?.presentStoreListView()
                }
                if let sheet = self?.storeListViewController.sheetPresentationController {
                    sheet.animateChanges {
                        sheet.selectedDetentIdentifier = .largeStoreListViewDetentIdentifier
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var dimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        view.alpha = 0.4
        view.rx.tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.action(
                    input: .dimViewTapGestureEnded
                )
            })
            .disposed(by: disposeBag)
        
        return view
    }()
    
    private lazy var refreshButtonBottomConstraint = refreshButton.bottomAnchor.constraint(
        equalTo: mapView.bottomAnchor, constant: -104
    )
    
    private lazy var moreStoreButtonBottomConstraint = moreStoreButton.bottomAnchor.constraint(
        equalTo: mapView.bottomAnchor, constant: -104
    )
    
    private lazy var locationButtonBottomConstraint = locationButton.bottomAnchor.constraint(
        equalTo: mapView.bottomAnchor, constant: -104
    )
    
    private lazy var researchKeywordButtonBottomConstraint = researchKeywordButton.bottomAnchor.constraint(
        equalTo: mapView.bottomAnchor, constant: -104
    )
    
    private lazy var addStoreButtonBottomConstraint = addStoreButton.bottomAnchor.constraint(
        equalTo: mapView.bottomAnchor, constant: -128
    )
    
    private lazy var searchBarViewLeadingConstraint = searchBarView.leadingAnchor.constraint(
        equalTo: mapView.leadingAnchor, constant: 16
    )
    
    private let viewModel: HomeViewModel
    private let storeListViewController: StoreListViewController
    private let storeInformationViewController: StoreInformationViewController
    private let searchViewController: SearchViewController
    private let newStoreRequeestViewController: NewStoreRequestViewController
    private let summaryViewHeightObserver: PublishRelay<SummaryViewHeightCase>
    private let listCellSelectedObserver: PublishRelay<Int>
    private let searchObserver: PublishRelay<String>
    private let refreshCameraPositionObserver: PublishRelay<NMFCameraPosition>
    private let endMoveCameraPositionObserver: PublishRelay<NMFCameraPosition>
    private let disposeBag = DisposeBag()
    private var markers: [Marker] = []
    private var clickedMarker: Marker?
    
    init(
        viewModel: HomeViewModel,
        storeListViewController: StoreListViewController,
        storeInformationViewController: StoreInformationViewController,
        searchViewController: SearchViewController,
        newStoreRequestViewController: NewStoreRequestViewController,
        summaryViewHeightObserver: PublishRelay<SummaryViewHeightCase>,
        listCellSelectedObserver: PublishRelay<Int>,
        searchObserver: PublishRelay<String>,
        refreshCameraPositionObserver: PublishRelay<NMFCameraPosition>,
        endMoveCameraPositionObserver: PublishRelay<NMFCameraPosition>
    ) {
        self.viewModel = viewModel
        self.storeListViewController = storeListViewController
        self.storeInformationViewController = storeInformationViewController
        self.searchViewController = searchViewController
        self.newStoreRequeestViewController = newStoreRequestViewController
        self.summaryViewHeightObserver = summaryViewHeightObserver
        self.listCellSelectedObserver = listCellSelectedObserver
        self.searchObserver = searchObserver
        self.refreshCameraPositionObserver = refreshCameraPositionObserver
        self.endMoveCameraPositionObserver = endMoveCameraPositionObserver
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUIComponents()
        configureConstraints()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setup()
    }
    
}

private extension HomeViewController {
    
    func setup() {
        unDimmedView()
        viewModel.action(
            input: .checkLocationAuthorization(
                status: locationManager.authorizationStatus
            )
        )
        storeListViewController.emptyStoreList()
        presentStoreListView()
    }
    
    func bind() {
        bindFetchStores()
        bindApplyFilters()
        bindSetMarker()
        bindLocationButton()
        bindLocationAuthorization()
        bindStoreInformationView()
        bindErrorAlert()
        bindListCellSelected()
        bindSearch()
        bindSearchResult()
        bindMoreStoreButton()
        bindRefreshCameraPosition()
        bindMapViewChanged()
    }
    
    func bindFetchStores() {
        viewModel.refreshDoneOutput
            .bind { [weak self] isHidden in
                self?.refreshButton.animationInvalidate()
                self?.refreshButton.isHidden = true
                self?.moreStoreButton.isHidden = isHidden
                self?.moreStoreButton.isEnabled = true
                self?.mapView.mapView.positionMode = .normal
                self?.locationButton.setImage(UIImage.locationButtonNone, for: .normal)
                self?.enableAllWhileLoading()
            }
            .disposed(by: disposeBag)
        
        viewModel.fetchCountOutput
            .bind { [weak self] fetchCount in
                self?.moreStoreButton.setFetchCount(fetchCount: fetchCount)
                self?.researchKeywordButton.animationInvalidate()
                self?.enableAllWhileLoading()
            }
            .disposed(by: disposeBag)
        
        viewModel.noMoreStoresOutput
            .bind { [weak self] in
                self?.moreStoreButton.isEnabled = false
                self?.enableAllWhileLoading()
            }
            .disposed(by: disposeBag)
    }
    
    func bindApplyFilters() {
        viewModel.filteredStoresOutput
            .throttle(.milliseconds(10), latest: false, scheduler: MainScheduler())
            .bind { [weak self] filteredStores in
                guard let self = self else { return }
                resetMarker()
                resetLayout()
                var stores: [Store] = []
                filteredStores.forEach { filteredStore in
                    filteredStore.stores.forEach { [weak self] store in
                        self?.viewModel.action(
                            input: .setMarker(
                                store: store,
                                certificationType: filteredStore.type
                            )
                        )
                        stores.append(store)
                    }
                }
                storeListViewController.updateList(stores: stores)
                storeInformationViewController.dismiss(animated: true) { [weak self] in
                    self?.presentStoreListView()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.noFilteredStoreOutput
            .throttle(.milliseconds(10), latest: false, scheduler: MainScheduler())
            .bind { [weak self] in
                self?.resetMarker()
                self?.resetLayout()
                self?.showToast(message: "검색 결과가 존재하지 않습니다.")
                self?.storeListViewController.emptyStoreList()
                self?.storeInformationViewController.dismiss(animated: true) { [weak self] in
                    self?.presentStoreListView()
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindSetMarker() {
        viewModel.setMarkerOutput
            .bind { [weak self] content in
                guard let selectImage = UIImage(named: content.selectImageName),
                      let deselectImage = UIImage(named: content.deselectImageName) else { return }
                let marker = Marker(position: content.location.toMapLocation(), selectImage: selectImage, deselectImage: deselectImage)
                marker.tag = UInt(content.tag)
                marker.mapView = self?.mapView.mapView
                self?.markerTouchHandler(marker: marker)
                self?.markers.append(marker)
            }
            .disposed(by: disposeBag)
    }
    
    func bindLocationButton() {
        viewModel.locationButtonOutput
            .bind { [weak self] positionMode in
                guard let imageName = positionMode.getImageName() else { return }
                self?.locationButton.setImage(UIImage(named: imageName), for: .normal)
                self?.mapView.mapView.positionMode = positionMode
                self?.enableAllWhileLoading()
            }
            .disposed(by: disposeBag)
        
        viewModel.requestLocationAuthorizationOutput
            .bind { [weak self] in
                self?.presentLocationAlert()
                self?.enableAllWhileLoading()
            }
            .disposed(by: disposeBag)
    }
    
    func bindStoreInformationView() {
        viewModel.getStoreInformationOutput
            .bind { [weak self] store in
                self?.storeInformationViewController.setUIContents(store: store)
                self?.changeButtonsConstraints(delay: false)
            }
            .disposed(by: disposeBag)
        
        viewModel.dimViewTapGestureEndedOutput
            .bind { [weak self] _ in
                self?.storeInformationViewController.changeToSummary()
                self?.unDimmedView()
            }
            .disposed(by: disposeBag)
        
        summaryViewHeightObserver.bind { [weak self] heightCase in
            guard let self = self else { return }
            if let sheet = storeInformationViewController.sheetPresentationController {
                sheet.animateChanges {
                    switch heightCase {
                    case .small:
                        sheet.detents = [.smallSummaryViewDetent, .detailViewDetent]
                        sheet.selectedDetentIdentifier = .smallSummaryDetentIdentifier
                    case .large:
                        sheet.detents = [.largeSummaryViewDetent, .detailViewDetent]
                        sheet.selectedDetentIdentifier = .largeSummaryDetentIdentifier
                    }
                }
                sheet.delegate = self
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 15
                sheet.largestUndimmedDetentIdentifier = .detailDetentIdentifier
            }
            storeInformationViewController.changeToSummary()
            if !(presentedViewController is StoreInformationViewController) {
                dismiss(animated: true)
                changeButtonsConstraints(delay: true)
                present(storeInformationViewController, animated: true) { [weak self] in
                    self?.enableAllWhileLoading()
                }
            } else {
                enableAllWhileLoading()
            }
        }
        .disposed(by: disposeBag)
    }
    
    func bindLocationAuthorization() {
        viewModel.locationAuthorizationStatusDeniedOutput
            .bind { [weak self] in
                self?.refresh()
            }
            .disposed(by: disposeBag)
        
        viewModel.locationStatusNotDeterminedOutput
            .bind { [weak self] in
                self?.locationManager.requestWhenInUseAuthorization()
                self?.locationButton.setImage(UIImage.locationButtonNone, for: .normal)
            }
            .disposed(by: disposeBag)
        
        viewModel.locationStatusAuthorizedWhenInUseOutput
            .throttle(.milliseconds(10), latest: false, scheduler: MainScheduler())
            .bind { [weak self] in
                guard let self = self else { return }
                guard let location = locationManager.location else { return }
                let cameraUpdate = NMFCameraUpdate(
                    scrollTo: NMGLatLng(
                        lat: location.coordinate.latitude,
                        lng: location.coordinate.longitude
                    )
                )
                cameraUpdate.animation = .none
                mapView.mapView.moveCamera(cameraUpdate)
                mapView.mapView.positionMode = .direction
                locationButton.setImage(UIImage.locationButtonNormal, for: .normal)
                refresh()
            }
            .disposed(by: disposeBag)
    }
    
    func bindFilterButton(button: FilterButton, type: CertificationType) {
        button.rx.tap
            .throttle(.milliseconds(10), latest: false, scheduler: MainScheduler())
            .scan(false) { [weak self] (lastState, _) in
                guard let self = self else { return lastState }
                if button.isUserInteractionEnabled == false {
                    return lastState
                }
                disableAllWhileLoading()
                viewModel.action(
                    input: .filterButtonTapped(activatedFilter: type)
                )
                return !lastState
            }
            .bind(to: button.rx.isSelected)
            .disposed(by: disposeBag)
    }
    
    func bindErrorAlert() {
        viewModel.errorAlertOutput
            .throttle(.milliseconds(10), latest: false, scheduler: MainScheduler())
            .bind { [weak self] error in
                self?.presentErrorAlert(error: error, completion: { [weak self] in
                    self?.enableAllWhileLoading()
                    self?.researchKeywordButton.animationInvalidate()
                    self?.refreshButton.animationInvalidate()
                })
            }
            .disposed(by: disposeBag)
    }
    
    func bindListCellSelected() {
        listCellSelectedObserver
            .throttle(.milliseconds(10), latest: false, scheduler: MainScheduler())
            .bind { [weak self] index in
                guard let self = self else { return }
                if markers.indices ~= index {
                    let targetMarker = markers[index]
                    
                    let cameraUpdate = NMFCameraUpdate(
                        position: NMFCameraPosition(targetMarker.position.toLatLng(), zoom: 15)
                    )
                    cameraUpdate.animation = .easeIn
                    mapView.mapView.moveCamera(cameraUpdate)
                    
                    viewModel.action(
                        input: .markerTapped(tag: targetMarker.tag)
                    )
                    targetMarker.select()
                    clickedMarker = targetMarker
                    
                    setBackStoreListButton(row: index)
                } else {
                    presentErrorAlert(error: .client)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindSearch() {
        searchObserver
            .bind { [weak self] keyword in
                guard let self = self else { return }
                let center = mapView.mapView.projection.latlng(from: view.center)
                let centerPosition = Location(
                    longitude: center.lng,
                    latitude: center.lat
                )
                viewModel.action(input: .search(location: centerPosition, keyword: keyword))
                searchBarView.searchTextField.text = keyword
                searchBarView.layer.borderWidth = 1.5
                researchKeywordButton.isHidden = false
                refreshButton.isHidden = true
                moreStoreButton.isHidden = true
            }
            .disposed(by: disposeBag)
    }
    
    func bindSearchResult() {
        viewModel.searchStoresOutput
            .bind { [weak self] stores in
                guard let self = self else { return }
                resetFilters()
                resetMarker()
                resetLayout()
                setMapViewPositionMode()
                setSearchStoresMarker(stores: stores)
                
                mapView.mapView.moveCamera(NMFCameraUpdate(heading: 0))
                let cameraUpdate = NMFCameraUpdate(
                    fit: NMGLatLngBounds(latLngs: markers.map({ $0.position })),
                    padding: 30
                )
                cameraUpdate.animation = .easeIn
                cameraUpdate.animationDuration = 0.5
                mapView.mapView.moveCamera(cameraUpdate)
                
                storeInformationViewController.dismiss(animated: true) { [weak self] in
                    self?.presentStoreListView()
                }
                researchKeywordButton.animationInvalidate()
            }
            .disposed(by: disposeBag)
        
        viewModel.searchOneStoreOutput
            .bind { [weak self] store in
                guard let self = self else { return }
                resetFilters()
                resetMarker()
                resetLayout()
                setMapViewPositionMode()
                setSearchStoresMarker(stores: [store])
                
                mapView.mapView.moveCamera(NMFCameraUpdate(heading: 0))
                let cameraUpdate = NMFCameraUpdate(
                    position: NMFCameraPosition(store.location.toMapLocation(), zoom: 15)
                )
                cameraUpdate.animation = .easeIn
                cameraUpdate.animationDuration = 0.5
                mapView.mapView.moveCamera(cameraUpdate)
                
                guard let marker = markers.first(where: { $0.tag == store.id }) else { return }
                if let clickedMarker = clickedMarker {
                    if clickedMarker == marker {
                        enableAllWhileLoading()
                        return
                    }
                }
                storeInformationViewController.setUIContents(store: store)
                marker.select()
                clickedMarker = marker
                researchKeywordButton.animationInvalidate()
            }
            .disposed(by: disposeBag)
        
        viewModel.noSearchStoreOutput
            .bind { [weak self] in
                self?.resetFilters()
                self?.resetMarker()
                self?.resetLayout()
                self?.setMapViewPositionMode()
                
                self?.storeInformationViewController.dismiss(animated: true) { [weak self] in
                    self?.presentStoreListView()
                }
                self?.showToast(message: "검색 결과가 존재하지 않습니다.")
                self?.storeListViewController.emptyStoreList()
                self?.researchKeywordButton.animationInvalidate()
            }
            .disposed(by: disposeBag)
    }
    
    func bindMoreStoreButton() {
        viewModel.moreStoreButtonHiddenOutput
            .bind { [weak self] in
                if self?.researchKeywordButton.isHidden == true {
                    self?.refreshButton.isHidden = false
                    self?.moreStoreButton.isHidden = true
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindRefreshCameraPosition() {
        Observable.combineLatest(refreshCameraPositionObserver, endMoveCameraPositionObserver)
            .observe(on: MainScheduler())
            .bind { [weak self] refreshCameraPosition, endMoveCameraPosition in
                guard let self = self else { return }
                viewModel.action(
                    input: .compareCameraPosition(
                        refreshCameraPosition: refreshCameraPosition,
                        endMoveCameraPosition: endMoveCameraPosition,
                        refreshCameraPoint: mapView.mapView.projection.point(from: refreshCameraPosition.target),
                        endMoveCameraPoint: mapView.mapView.projection.point(from: endMoveCameraPosition.target)
                    )
                )
            }
            .disposed(by: disposeBag)
    }
    
    func bindMapViewChanged() {
        viewModel.mapViewChangedByGesture
            .bind { [weak self] in
                self?.locationButton.setImage(UIImage.locationButtonNone, for: .normal)
            }
            .disposed(by: disposeBag)
    }
    
}

private extension HomeViewController {
    
    func markerTouchHandler(marker: Marker) {
        marker.touchHandler = { [weak self] (_: NMFOverlay) -> Bool in
            if self?.mapView.isUserInteractionEnabled == true {
                self?.disableAllWhileLoading()
                if let clickedMarker = self?.clickedMarker {
                    if clickedMarker == marker {
                        self?.enableAllWhileLoading()
                        return true
                    }
                    self?.backStoreListButton.isHidden = true
                    self?.searchBarViewLeadingConstraint.constant = 16
                    self?.clickedMarker?.deselect()
                    self?.clickedMarker = nil
                }
                
                self?.viewModel.action(
                    input: .markerTapped(tag: marker.tag)
                )
                marker.select()
                self?.clickedMarker = marker
                
                return true
            } else {
                return false
            }
        }
    }
    
    func dimmedView() {
        dimView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.dimView.backgroundColor = .black
        }
    }
    
    func unDimmedView() {
        dimView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.dimView.backgroundColor = .clear
        }
        if let sheet = storeInformationViewController.sheetPresentationController {
            sheet.animateChanges {
                sheet.selectedDetentIdentifier = .smallSummaryDetentIdentifier
            }
        }
    }
    
    func makeRequestLocation(projection: NMFProjection) -> RequestLocation {
        let northWestPoint = projection.latlng(from: CGPoint(x: 0 + 10, y: filterButtonStackView.frame.maxY + 10))
        let southWestPoint = projection.latlng(from: CGPoint(x: 0 + 10, y: locationButton.frame.minY - 10))
        let southEastPoint = projection.latlng(from: CGPoint(x: view.frame.width - 10, y: locationButton.frame.minY - 10))
        let northEastPoint = projection.latlng(from: CGPoint(x: view.frame.width - 10, y: filterButtonStackView.frame.maxY))
        
        return RequestLocation(
            northWest: Location(
                longitude: northWestPoint.lng,
                latitude: northWestPoint.lat
            ),
            southWest: Location(
                longitude: southWestPoint.lng,
                latitude: southWestPoint.lat
            ),
            southEast: Location(
                longitude: southEastPoint.lng,
                latitude: southEastPoint.lat
            ),
            northEast: Location(
                longitude: northEastPoint.lng,
                latitude: northEastPoint.lat
            )
        )
    }
    
    func refresh() {
        disableAllWhileLoading()
        refreshButton.animationFire()
        viewModel.action(
            input: .refresh(
                requestLocation: makeRequestLocation(projection: mapView.mapView.projection)
            )
        )
        refreshCameraPositionObserver.accept(mapView.mapView.cameraPosition)
    }
    
    func setBackStoreListButton(row: Int) {
        storeListViewController.scrollToPreviousCell(indexPath: IndexPath(row: row, section: 0))
        backStoreListButton.isHidden = false
        searchBarViewLeadingConstraint.constant = 62
    }
    
    func presentSearchViewController() {
        searchViewController.setSearchKeyword(keyword: searchBarView.searchTextField.text)
        if let presentedViewController = presentedViewController {
            presentedViewController.present(searchViewController, animated: false) { [weak self] in
                self?.enableAllWhileLoading()
            }
        } else {
            enableAllWhileLoading()
        }
    }
    
    func presentStoreListView() {
        if !(presentedViewController is StoreListViewController) {
            if let sheet = storeListViewController.sheetPresentationController {
                sheet.detents = [.smallStoreListViewDetent, .largeStoreListViewDetent]
                sheet.largestUndimmedDetentIdentifier = .smallStoreListViewDetentIdentifier
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 15
            }
            refreshButtonBottomConstraint.constant = -104
            locationButtonBottomConstraint.constant = -104
            moreStoreButtonBottomConstraint.constant = -104
            researchKeywordButtonBottomConstraint.constant = -104
            addStoreButtonBottomConstraint.constant = -128
            mapView.mapView.logoMargin.bottom = 69
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            present(storeListViewController, animated: true) { [weak self] in
                self?.enableAllWhileLoading()
            }
        } else {
            enableAllWhileLoading()
        }
    }
    
}

private extension HomeViewController {
    
    func addUIComponents() {
        view.addSubview(mapView)
        mapView.addSubview(locationButton)
        mapView.addSubview(filterButtonStackView)
        mapView.addSubview(searchBarView)
        mapView.addSubview(refreshButton)
        mapView.addSubview(moreStoreButton)
        mapView.addSubview(researchKeywordButton)
        mapView.addSubview(backStoreListButton)
        mapView.addSubview(addStoreButton)
        mapView.addSubview(dimView)
    }
    
    func configureConstraints() {
        viewConstraints()
        buttonConstraints()
    }
    
    func viewConstraints() {
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            dimView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 0),
            dimView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: 0),
            dimView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 0),
            dimView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBarView.trailingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchBarView.heightAnchor.constraint(equalToConstant: 50),
            searchBarViewLeadingConstraint
        ])
        
        NSLayoutConstraint.activate([
            filterButtonStackView.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            filterButtonStackView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 8)
        ])
    }
    
    func buttonConstraints() {
        NSLayoutConstraint.activate([
            locationButton.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            locationButton.widthAnchor.constraint(equalToConstant: 48),
            locationButton.heightAnchor.constraint(equalToConstant: 48),
            locationButtonBottomConstraint
        ])
        
        NSLayoutConstraint.activate([
            refreshButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            refreshButton.widthAnchor.constraint(equalToConstant: 119),
            refreshButton.heightAnchor.constraint(equalToConstant: 35),
            refreshButtonBottomConstraint
        ])
        
        NSLayoutConstraint.activate([
            moreStoreButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            moreStoreButton.widthAnchor.constraint(equalToConstant: 97),
            moreStoreButton.heightAnchor.constraint(equalToConstant: 35),
            moreStoreButtonBottomConstraint
        ])
        
        NSLayoutConstraint.activate([
            researchKeywordButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            researchKeywordButton.widthAnchor.constraint(equalToConstant: 140),
            researchKeywordButton.heightAnchor.constraint(equalToConstant: 35),
            researchKeywordButtonBottomConstraint
        ])
        
        NSLayoutConstraint.activate([
            backStoreListButton.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            backStoreListButton.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
            backStoreListButton.widthAnchor.constraint(equalToConstant: 38),
            backStoreListButton.heightAnchor.constraint(equalToConstant: 38)
        ])
        
        NSLayoutConstraint.activate([
            addStoreButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16),
            addStoreButton.widthAnchor.constraint(equalToConstant: 34),
            addStoreButton.heightAnchor.constraint(equalToConstant: 34),
            addStoreButtonBottomConstraint
        ])
    }
    
    func changeButtonsConstraints(delay: Bool) {
        guard let controller = storeInformationViewController.sheetPresentationController else { return }
        if controller.detents.contains(.smallSummaryViewDetent) {
            refreshButtonBottomConstraint.constant = -260
            locationButtonBottomConstraint.constant = -260
            moreStoreButtonBottomConstraint.constant = -260
            researchKeywordButtonBottomConstraint.constant = -260
            addStoreButtonBottomConstraint.constant = -284
            mapView.mapView.logoMargin.bottom = 225
        } else {
            refreshButtonBottomConstraint.constant = -283
            locationButtonBottomConstraint.constant = -283
            moreStoreButtonBottomConstraint.constant = -283
            researchKeywordButtonBottomConstraint.constant = -283
            addStoreButtonBottomConstraint.constant = -307
            mapView.mapView.logoMargin.bottom = 248
        }
        UIView.animate(withDuration: 0.3, delay: delay ? 0.5 : 0) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func resetFilters() {
        safeFilterButton.isSelected = false
        exemplaryFilterButton.isSelected = false
        goodPriceFilterButton.isSelected = false
        viewModel.action(input: .resetFilters)
    }
    
    func resetMarker() {
        markers.forEach({ $0.mapView = nil })
        markers = []
    }
    
    func resetLayout() {
        backStoreListButton.isHidden = true
        searchBarViewLeadingConstraint.constant = 16
        clickedMarker?.deselect()
        clickedMarker = nil
    }
    
    func setMapViewPositionMode() {
        mapView.mapView.positionMode = .normal
        locationButton.setImage(UIImage.locationButtonNone, for: .normal)
    }
    
    func setSearchStoresMarker(stores: [Store]) {
        stores.forEach { [weak self] store in
            guard let certificationType = store.certificationTypes.last else { return }
            self?.viewModel.action(input: .setMarker(
                store: store,
                certificationType: certificationType
            ))
        }
        storeListViewController.updateList(stores: stores)
    }
    
    func showToast(message: String) {
        let toastView = makeToastView(message: message)
        
        let windows = UIApplication.shared.connectedScenes
        let scene = windows.first { $0.activationState == .foregroundActive }
        if let windowScene = scene as? UIWindowScene, let windowView = windowScene.windows.first {
            windowView.addSubview(toastView)
            NSLayoutConstraint.activate([
                toastView.centerXAnchor.constraint(equalTo: windowView.safeAreaLayoutGuide.centerXAnchor),
                toastView.bottomAnchor.constraint(equalTo: windowView.safeAreaLayoutGuide.bottomAnchor, constant: -61)
            ])
        }
        toastView.removeFromSuperviewWithAnimation()
    }
    
    func disableAllWhileLoading() {
        goodPriceFilterButton.isUserInteractionEnabled = false
        exemplaryFilterButton.isUserInteractionEnabled = false
        safeFilterButton.isUserInteractionEnabled = false
        searchBarView.searchTextField.isUserInteractionEnabled = false
        searchBarView.searchImageView.isUserInteractionEnabled = false
        searchBarView.xMarkImageView.isUserInteractionEnabled = false
        mapView.isUserInteractionEnabled = false
        refreshButton.isUserInteractionEnabled = false
        moreStoreButton.isUserInteractionEnabled = false
        researchKeywordButton.isUserInteractionEnabled = false
        backStoreListButton.isUserInteractionEnabled = false
        addStoreButton.isUserInteractionEnabled = false
    }
    
    func enableAllWhileLoading() {
        goodPriceFilterButton.isUserInteractionEnabled = true
        exemplaryFilterButton.isUserInteractionEnabled = true
        safeFilterButton.isUserInteractionEnabled = true
        searchBarView.searchTextField.isUserInteractionEnabled = true
        searchBarView.searchImageView.isUserInteractionEnabled = true
        searchBarView.xMarkImageView.isUserInteractionEnabled = true
        mapView.isUserInteractionEnabled = true
        refreshButton.isUserInteractionEnabled = true
        moreStoreButton.isUserInteractionEnabled = true
        researchKeywordButton.isUserInteractionEnabled = true
        backStoreListButton.isUserInteractionEnabled = true
        addStoreButton.isUserInteractionEnabled = true
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        viewModel.action(
            input: .checkLocationAuthorization(
                status: locationManager.authorizationStatus
            )
        )
    }
    
}

extension HomeViewController: NMFMapViewCameraDelegate {
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        viewModel.action(input: .mapViewChanged(reason: reason))
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        endMoveCameraPositionObserver.accept(mapView.cameraPosition)
        enableAllWhileLoading()
    }
    
}

extension HomeViewController: NMFMapViewTouchDelegate {
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        if self.mapView.isUserInteractionEnabled == true {
            disableAllWhileLoading()
            backStoreListButton.isHidden = true
            searchBarViewLeadingConstraint.constant = 16
            clickedMarker?.deselect()
            clickedMarker = nil
            storeInformationViewController.dismiss(animated: true) { [weak self] in
                self?.presentStoreListView()
            }
        }
    }
    
}

extension HomeViewController: UISheetPresentationControllerDelegate {
    
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(
        _ sheetPresentationController: UISheetPresentationController
    ) {
        if let identifier = sheetPresentationController.selectedDetentIdentifier {
            switch identifier {
            case .smallSummaryDetentIdentifier, .largeSummaryDetentIdentifier:
                storeInformationViewController.changeToSummary()
                unDimmedView()
            case .detailDetentIdentifier:
                storeInformationViewController.changeToDetail()
                dimmedView()
            default:
                break
            }
        }
    }
    
}

extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
}
