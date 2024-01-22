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

final class HomeViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
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
                
                checkLocationService()
                switch mapView.mapView.positionMode {
                case .direction:
                    button.setImage(UIImage.locationButtonCompass, for: .normal)
                    mapView.mapView.positionMode = .compass
                case .compass, .normal:
                    button.setImage(UIImage.locationButtonNormal, for: .normal)
                    mapView.mapView.positionMode = .direction
                default:
                    break
                }
            }
            .disposed(by: self.disposeBag)
        button.setImage(UIImage.locationButtonNone, for: .normal)
        
        return button
    }()
    
    private var markers: [Marker] = []
    private var clickedMarker: Marker?
    
    private lazy var mapView: NMFNaverMapView = {
        let map = NMFNaverMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showZoomControls = false
        map.showCompass = false
        map.showScaleBar = false
        map.showIndoorLevelPicker = false
        map.showLocationButton = false
        map.mapView.logoAlign = .rightBottom
        map.mapView.touchDelegate = self
        map.mapView.addCameraDelegate(delegate: self)
        
        return map
    }()
        
    private lazy var locationBottomConstraint = locationButton.bottomAnchor.constraint(
        equalTo: mapView.safeAreaLayoutGuide.bottomAnchor,
        constant: -16
    )
    private lazy var refreshBottomConstraint = refreshButton.bottomAnchor.constraint(
        equalTo: mapView.safeAreaLayoutGuide.bottomAnchor,
        constant: -17
    )
    
    private let requestLocationServiceAlert: UIAlertController = {
        let alertController = UIAlertController(
            title: "위치 정보 이용",
            message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.",
            preferredStyle: .alert
        )
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(cancel)
        alertController.addAction(goSetting)
        
        return alertController
    }()
    
    private lazy var refreshButton: RefreshButton = {
        let button = RefreshButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                let northWestPoint = mapView.mapView.projection.latlng(from: CGPoint(x: 0, y: 0))
                let southWestPoint = mapView.mapView.projection.latlng(from: CGPoint(x: 0, y: view.frame.height))
                let southEastPoint = mapView.mapView.projection.latlng(from: CGPoint(x: view.frame.width, y: view.frame.height))
                let northEastPoint = mapView.mapView.projection.latlng(from: CGPoint(x: view.frame.width, y: 0))
                viewModel.action(
                    input: .refresh(
                        requestLocation: RequestLocation(
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
                        ),
                        filters: getActivatedTypes()
                    )
                )
                refreshButton.isHidden = true
            }
            .disposed(by: self.disposeBag)
        
        return button
    }()
    
    private var activatedFilter: [CertificationType] = []
    
    private var storeInformationViewController: StoreInformationViewController?
    
    private let dismissObserver = PublishRelay<Bool>()
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUIComponents()
        configureConstraints()
        checkUserCurrentLocationAuthorization()
        bind()
    }
    
}

private extension HomeViewController {
    
    func bind() {
        viewModel.refreshOutput
            .bind { [weak self] filteredStores in
                guard let self = self else { return }
                self.markers.forEach { $0.mapView = nil }
                filteredStores.forEach { filteredStore in
                    filteredStore.stores.forEach {
                        let location = $0.location.toMapLocation()
                        self.setMarker(marker: Marker(certificationType: filteredStore.type, position: location), tag: UInt($0.id))
                    }
                }
                markerCancel()
            }
            .disposed(by: disposeBag)
        
        viewModel.getStoreInformationOutput
            .bind { [weak self] store in
                guard let self = self else { return }
                presentStoreView()
                storeInformationViewController?.setUIContents(store: store)
            }
            .disposed(by: disposeBag)
    }
    
    func bindFilterButton(button: FilterButton, type: CertificationType) {
        button.rx.tap
            .scan(false) { [weak self] (lastState, _) in
                guard let self = self else { return lastState }
                if lastState {
                    guard let lastIndex = activatedFilter.lastIndex(of: type) else { return lastState }
                    activatedFilter.remove(at: lastIndex)
                } else {
                    activatedFilter.append(type)
                }
                viewModel.action(input: .fetchFilteredStores(filters: getActivatedTypes()))
                return !lastState
            }
            .bind(to: button.rx.isSelected)
            .disposed(by: disposeBag)
    }
    
    func setMarker(marker: Marker, tag: UInt) {
        marker.tag = tag
        marker.mapView = mapView.mapView
        markerTouchHandler(marker: marker)
        markers.append(marker)
    }
    
    func getActivatedTypes() -> [CertificationType] {
        if activatedFilter.isEmpty {
            return [.safe, .exemplary, .goodPrice]
        }
        
        return activatedFilter
    }
    
}

private extension HomeViewController {
    
    func markerTouchHandler(marker: Marker) {
        marker.touchHandler = { [weak self] (_: NMFOverlay) -> Bool in
            guard let self = self else { return true }
            markerCancel()
            if clickedMarker != marker {
                clickedMarker?.isSelected = false
            }
            marker.isSelected.toggle()
            if marker.isSelected {
                viewModel.action(input: .markerTapped(tag: marker.tag))
            }
            clickedMarker = marker
            
            return true
        }
    }
    
    func markerClicked(height: CGFloat) {
        mapView.mapView.logoMargin = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        locationBottomConstraint.constant = -height
        refreshBottomConstraint.constant = -height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func markerCancel() {
        mapView.mapView.logoMargin = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        locationBottomConstraint.constant = -16
        refreshBottomConstraint.constant = -17
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        storeInformationViewController?.dismiss(animated: true)
    }
    
    func presentStoreView() {
        let storeViewModel = StoreInformationViewModelImpl(
            getOpenClosedUseCase: GetOpenClosedUseCaseImpl(),
            fetchImageUseCase: FetchImageUseCaseImpl(repository: ImageRepositoryImpl())
        )
        let contentHeightObserver = PublishRelay<CGFloat>()
        storeInformationViewController = StoreInformationViewController(
            viewModel: storeViewModel,
            contentHeightObserver: contentHeightObserver,
            dismissObserver: dismissObserver
        )
        storeInformationViewController?.transitioningDelegate = self
        
        if let viewController = storeInformationViewController {
            contentHeightObserver
                .bind { [weak self] contentHeight in
                    guard let self = self else { return }
                    let bottomSafeArea: CGFloat = 34
                    let height = contentHeight - bottomSafeArea
                    if let sheet = viewController.sheetPresentationController {
                        let detentIdentifier = UISheetPresentationController.Detent.Identifier("detent")
                        let detent = UISheetPresentationController.Detent.custom(identifier: detentIdentifier) { _ in
                            return height
                        }
                        sheet.detents = [detent]
                        sheet.largestUndimmedDetentIdentifier = detentIdentifier
                        sheet.preferredCornerRadius = 15
                    }
                    markerClicked(height: contentHeight - bottomSafeArea + 16)
                }
                .disposed(by: disposeBag)
            present(viewController, animated: true)
        }
    }
    
}

private extension HomeViewController {
    
    func checkUserCurrentLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationButton.setImage(UIImage.locationButtonNone, for: .normal)
        case .authorizedWhenInUse:
            guard let location = locationManager.location else { return }
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude))
            cameraUpdate.animation = .none
            mapView.mapView.moveCamera(cameraUpdate)
        default:
            break
        }
    }
    
    func checkLocationService() {
        if locationManager.authorizationStatus == .denied {
            present(requestLocationServiceAlert, animated: true)
        }
    }
    
}

private extension HomeViewController {
    
    func addUIComponents() {
        view.addSubview(mapView)
        mapView.addSubview(locationButton)
        mapView.addSubview(filterButtonStackView)
        mapView.addSubview(refreshButton)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            locationButton.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            locationButton.widthAnchor.constraint(equalToConstant: 48),
            locationButton.heightAnchor.constraint(equalToConstant: 48),
            locationBottomConstraint
        ])
        
        NSLayoutConstraint.activate([
            filterButtonStackView.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            filterButtonStackView.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            refreshButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            refreshBottomConstraint
        ])
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserCurrentLocationAuthorization()
    }
    
}

extension HomeViewController: NMFMapViewCameraDelegate {
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        if reason == NMFMapChangedByGesture {
            locationButton.setImage(UIImage.locationButtonNone, for: .normal)
        }
        refreshButton.isHidden = false
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        if reason == NMFMapChangedByDeveloper {
            mapView.positionMode = .direction
            locationButton.setImage(UIImage.locationButtonNormal, for: .normal)
            
            let northWestPoint = mapView.projection.latlng(from: CGPoint(x: 0, y: 0))
            let southWestPoint = mapView.projection.latlng(from: CGPoint(x: 0, y: view.frame.height))
            let southEastPoint = mapView.projection.latlng(from: CGPoint(x: view.frame.width, y: view.frame.height))
            let northEastPoint = mapView.projection.latlng(from: CGPoint(x: view.frame.width, y: 0))
            viewModel.action(
                input: .refresh(
                    requestLocation: RequestLocation(
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
                    ),
                    filters: getActivatedTypes()
                )
            )
            refreshButton.isHidden = true
        }
    }
    
}

extension HomeViewController: NMFMapViewTouchDelegate {
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        clickedMarker?.isSelected = false
        markerCancel()
    }
    
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        dismissObserver
            .bind { [weak self] bool in
                guard let self = self else { return }
                if bool {
                    clickedMarker?.isSelected = false
                    locationBottomConstraint.constant = -16
                    refreshBottomConstraint.constant = -17
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return nil
    }
    
}
