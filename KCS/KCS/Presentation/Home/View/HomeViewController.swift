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
        
        view.xMarkImageView.rx
            .tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
                // TODO: 검색 초기화 처리
                view.searchTextField.text = ""
            })
            .disposed(by: disposeBag)
        
        view.searchImageView.rx
            .tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
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
    
    private lazy var compassView: NMFCompassView = {
        let compass = NMFCompassView()
        compass.translatesAutoresizingMaskIntoConstraints = false
        compass.mapView = mapView.mapView
        
        return compass
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
        map.mapView.logoMargin = UIEdgeInsets(top: 0, left: 0, bottom: 55, right: 0)
        map.mapView.touchDelegate = self
        map.mapView.addCameraDelegate(delegate: self)
        
        return map
    }()
    
    private lazy var refreshButton: RefreshButton = {
        let button = RefreshButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rx.tap
            .debounce(.milliseconds(10), scheduler: MainScheduler())
            .map { [weak self] _ -> RequestLocation? in
                guard let self = self else { return nil }
                button.animationFire()
                
                return makeRequestLocation(projection: mapView.mapView.projection)
            }
            .observe(on: ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()))
            .bind { [weak self] requestLocation in
                guard let self = self, let location = requestLocation else { return }
                viewModel.action(
                    input: .refresh(
                        requestLocation: location
                    )
                )
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var moreStoreButton: MoreStoreButton = {
        let button = MoreStoreButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.rx.tap
            .debounce(.milliseconds(100), scheduler: MainScheduler())
            .bind { [weak self] in
                self?.viewModel.action(
                    input: .moreStoreButtonTapped
                )
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    // TODO: BackButton configuration 수정 필요
    private lazy var backStoreListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("뒤로가기", for: .normal)
        button.isHidden = true
        button.rx.tap
            .debounce(.milliseconds(100), scheduler: MainScheduler())
            .bind { [weak self] in
                self?.storeInformationViewDismiss()
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
        equalTo: mapView.bottomAnchor, constant: -90
    )
    
    private lazy var moreStoreButtonBottomConstraint = moreStoreButton.bottomAnchor.constraint(
        equalTo: mapView.bottomAnchor, constant: -90
    )
    
    private lazy var locationButtonBottomConstraint = locationButton.bottomAnchor.constraint(
        equalTo: mapView.bottomAnchor, constant: -90
    )
    
    private let searchViewController: SearchViewController
    private let searchObserver: PublishRelay<String>
    private let disposeBag = DisposeBag()
    private var markers: [Marker] = []
    private let storeInformationViewController: StoreInformationViewController
    private var clickedMarker: Marker?
    private let storeListViewController: StoreListViewController
    private let viewModel: HomeViewModel
    private let summaryViewHeightObserver: PublishRelay<SummaryViewHeightCase>
    private let listCellSelectedObserver: PublishRelay<Int>
    
    init(
        viewModel: HomeViewModel,
        storeInformationViewController: StoreInformationViewController,
        storeListViewController: StoreListViewController,
        summaryViewHeightObserver: PublishRelay<SummaryViewHeightCase>,
        listCellSelectedObserver: PublishRelay<Int>,
        searchViewController: SearchViewController,
        searchObserver: PublishRelay<String>
    ) {
        self.viewModel = viewModel
        self.storeInformationViewController = storeInformationViewController
        self.storeListViewController = storeListViewController
        self.summaryViewHeightObserver = summaryViewHeightObserver
        self.listCellSelectedObserver = listCellSelectedObserver
        self.searchViewController = searchViewController
        self.searchObserver = searchObserver
        
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
        setup()
        refresh()
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
        navigationController?.isNavigationBarHidden = true
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
    }
    
    func bindFetchStores() {
        viewModel.refreshDoneOutput
            .bind { [weak self] isEntire in
                self?.refreshButton.animationInvalidate()
                self?.refreshButton.isHidden = true
                self?.moreStoreButton.isHidden = isEntire
                self?.moreStoreButton.isEnabled = true
                self?.mapView.mapView.positionMode = .normal
                self?.locationButton.setImage(UIImage.locationButtonNone, for: .normal)
            }
            .disposed(by: disposeBag)
        
        viewModel.fetchCountOutput
            .bind { [weak self] fetchCount in
                self?.moreStoreButton.setFetchCount(fetchCount: fetchCount)
            }
            .disposed(by: disposeBag)
        
        viewModel.noMoreStoresOutput
            .bind { [weak self] in
                self?.moreStoreButton.isEnabled = false
            }
            .disposed(by: disposeBag)
    }
    
    func bindApplyFilters() {
        viewModel.filteredStoresOutput
            .debounce(.milliseconds(100), scheduler: MainScheduler())
            .bind { [weak self] filteredStores in
                guard let self = self else { return }
                self.markers.forEach { $0.mapView = nil }
                self.markers = []
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
                storeInformationViewDismiss()
                storeListViewController.updateList(stores: stores)
                if stores.isEmpty {
                    showToast(message: "가게가 없습니다.")
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
            }
            .disposed(by: disposeBag)
        
        viewModel.locationButtonImageNameOutput
            .bind { [weak self] imageName in
                self?.locationButton.setImage(UIImage(named: imageName), for: .normal)
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
                present(storeInformationViewController, animated: true)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func bindLocationAuthorization() {
        viewModel.locationAuthorizationStatusDeniedOutput
            .bind { [weak self] _ in
                guard let self = self else { return }
                presentLocationAlert()
            }
            .disposed(by: disposeBag)
        
        viewModel.locationStatusNotDeterminedOutput
            .bind { [weak self] _ in
                self?.locationManager.requestWhenInUseAuthorization()
                self?.locationButton.setImage(UIImage.locationButtonNone, for: .normal)
            }
            .disposed(by: disposeBag)
        
        viewModel.locationStatusAuthorizedWhenInUse
            .debounce(.milliseconds(10), scheduler: MainScheduler())
            .bind { [weak self] _ in
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
                refresh()
            }
            .disposed(by: disposeBag)
    }
    
    func bindFilterButton(button: FilterButton, type: CertificationType) {
        button.rx.tap
            .scan(false) { [weak self] (lastState, _) in
                guard let self = self else { return lastState }
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
            .debounce(.milliseconds(100), scheduler: MainScheduler())
            .bind { [weak self] error in
                self?.presentErrorAlert(error: error)
            }
            .disposed(by: disposeBag)
    }
    
    func bindListCellSelected() {
        listCellSelectedObserver
            .debounce(.milliseconds(10), scheduler: MainScheduler())
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
                guard let center = self?.view.center else { return }
                let centerPosition = Location(
                    longitude: Double(center.x),
                    latitude: Double(center.y)
                )
                self?.viewModel.action(input: .search(location: centerPosition, keyword: keyword))
                self?.searchBarView.searchTextField.text = keyword
            }
            .disposed(by: disposeBag)
        
        viewModel.searchStoresOutput
            .bind { [weak self] stores in
                guard let self = self else { return }
                resetFilters()
                storeInformationViewDismiss()
                setSearchStoresMarker(stores: stores)
                
                mapView.mapView.moveCamera(NMFCameraUpdate(heading: 0))
                if !stores.isEmpty {
                    let cameraUpdate = NMFCameraUpdate(
                        fit: NMGLatLngBounds(latLngs: markers.map({ $0.position })),
                        padding: 30
                    )
                    cameraUpdate.animation = .easeIn
                    cameraUpdate.animationDuration = 0.5
                    mapView.mapView.moveCamera(cameraUpdate)
                }
                mapView.mapView.positionMode = .normal
            }
            .disposed(by: disposeBag)
        
        viewModel.searchOneStoreOutput
            .bind { [weak self] store in
                guard let self = self else { return }
                resetFilters()
                setSearchStoresMarker(stores: [store])
                
                mapView.mapView.moveCamera(NMFCameraUpdate(heading: 0))
                
                let cameraUpdate = NMFCameraUpdate(
                    position: NMFCameraPosition(store.location.toMapLocation(), zoom: 15)
                )
                cameraUpdate.animation = .easeIn
                cameraUpdate.animationDuration = 0.5
                mapView.mapView.moveCamera(cameraUpdate)
                mapView.mapView.positionMode = .normal
                
                guard let marker = markers.first(where: { $0.tag == store.id}) else { return }
                if let clickedMarker = clickedMarker {
                    if clickedMarker == marker { return }
                    storeInformationViewDismiss(changeMarker: true)
                }
                storeInformationViewController.setUIContents(store: store)
                marker.select()
                clickedMarker = marker
            }
            .disposed(by: disposeBag)
    }
    
}

private extension HomeViewController {
    
    func markerTouchHandler(marker: Marker) {
        marker.touchHandler = { [weak self] (_: NMFOverlay) -> Bool in
            
            if let clickedMarker = self?.clickedMarker {
                if clickedMarker == marker { return true }
                self?.storeInformationViewDismiss(changeMarker: true)
            }
            
            self?.viewModel.action(
                input: .markerTapped(tag: marker.tag)
            )
            marker.select()
            self?.clickedMarker = marker
            
            return true
        }
    }
    
    func storeInformationViewDismiss(changeMarker: Bool = false) {
        backStoreListButton.isHidden = true
        clickedMarker?.deselect()
        clickedMarker = nil
        if !changeMarker {
            storeInformationViewController.dismiss(animated: true)
            presentStoreListView()
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
        let northWestPoint = projection.latlng(from: CGPoint(x: 0, y: 0))
        let southWestPoint = projection.latlng(from: CGPoint(x: 0, y: view.frame.height))
        let southEastPoint = projection.latlng(from: CGPoint(x: view.frame.width, y: view.frame.height))
        let northEastPoint = projection.latlng(from: CGPoint(x: view.frame.width, y: 0))
        
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
        refreshButton.animationFire()
        viewModel.action(
            input: .refresh(
                requestLocation: makeRequestLocation(projection: mapView.mapView.projection)
            )
        )
    }
    
    func setBackStoreListButton(row: Int) {
        storeListViewController.scrollToPreviousCell(indexPath: IndexPath(row: row, section: 0))
        backStoreListButton.isHidden = false
    }
    
    func presentSearchViewController() {
        searchViewController.setSearchKeyword(keyword: searchBarView.searchTextField.text)
        if let presentedViewController = presentedViewController {
            presentedViewController.present(searchViewController, animated: false)
        }
    }
    
}

private extension HomeViewController {
    
    func addUIComponents() {
        view.addSubview(mapView)
        mapView.addSubview(locationButton)
        mapView.addSubview(filterButtonStackView)
        mapView.addSubview(searchBarView)
        mapView.addSubview(compassView)
        mapView.addSubview(refreshButton)
        mapView.addSubview(moreStoreButton)
        mapView.addSubview(backStoreListButton)
        mapView.addSubview(dimView)
    }
    
    func configureConstraints() {
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
            locationButton.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            locationButton.widthAnchor.constraint(equalToConstant: 48),
            locationButton.heightAnchor.constraint(equalToConstant: 48),
            locationButtonBottomConstraint
        ])
        
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBarView.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBarView.trailingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchBarView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            filterButtonStackView.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            filterButtonStackView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            compassView.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            compassView.topAnchor.constraint(equalTo: filterButtonStackView.bottomAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            refreshButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            refreshButton.widthAnchor.constraint(equalToConstant: 110),
            refreshButton.heightAnchor.constraint(equalToConstant: 35),
            refreshButtonBottomConstraint
        ])
        
        NSLayoutConstraint.activate([
            moreStoreButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            moreStoreButton.widthAnchor.constraint(equalToConstant: 97),
            moreStoreButtonBottomConstraint
        ])
        
        // TODO: BackButton AutoLayout 수정 필요
        NSLayoutConstraint.activate([
            backStoreListButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            backStoreListButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -290),
            backStoreListButton.widthAnchor.constraint(equalToConstant: 80),
            backStoreListButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    func changeButtonsConstraints(delay: Bool) {
        guard let controller = storeInformationViewController.sheetPresentationController else { return }
        if controller.detents.contains(.smallSummaryViewDetent) {
            refreshButtonBottomConstraint.constant = -260
            locationButtonBottomConstraint.constant = -260
            moreStoreButtonBottomConstraint.constant = -260
            mapView.mapView.logoMargin.bottom = 225
        } else {
            refreshButtonBottomConstraint.constant = -283
            locationButtonBottomConstraint.constant = -283
            moreStoreButtonBottomConstraint.constant = -283
            mapView.mapView.logoMargin.bottom = 248
        }
        UIView.animate(withDuration: 0.3, delay: delay ? 0.5 : 0) {
            self.view.layoutIfNeeded()
        }
    }
    
    func resetFilters() {
        safeFilterButton.isSelected = false
        exemplaryFilterButton.isSelected = false
        goodPriceFilterButton.isSelected = false
        viewModel.action(input: .resetFilters)
    }
    
    func setSearchStoresMarker(stores: [Store]) {
        markers.forEach({ $0.mapView = nil })
        markers = []
        stores.forEach { [weak self] store in
            guard let certificationType = store.certificationTypes.last else { return }
            self?.viewModel.action(input: .setMarker(
                store: store,
                certificationType: certificationType
            ))
        }
        storeListViewController.updateList(stores: stores)
        if stores.isEmpty {
            showToast(message: "가게가 없습니다.")
        }
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
        if reason == NMFMapChangedByGesture {
            locationButton.setImage(UIImage.locationButtonNone, for: .normal)
        }
        refreshButton.isHidden = false
        moreStoreButton.isHidden = true
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        if reason == NMFMapChangedByDeveloper {
            viewModel.action(input:
                    .checkLocationAuthorizationWhenCameraDidChange(
                        status: locationManager.authorizationStatus
                    )
            )
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
            refreshButtonBottomConstraint.constant = -90
            locationButtonBottomConstraint.constant = -90
            moreStoreButtonBottomConstraint.constant = -90
            mapView.mapView.logoMargin.bottom = 55
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            present(storeListViewController, animated: true)
        }
    }
    
}

extension HomeViewController: NMFMapViewTouchDelegate {
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        storeInformationViewDismiss()
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
        presentSearchViewController()
        return false
    }
    
}
