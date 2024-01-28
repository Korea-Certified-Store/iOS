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
        map.mapView.logoAlign = .rightTop
        map.mapView.logoMargin = UIEdgeInsets(top: 28, left: 0, bottom: 0, right: 0)
        map.mapView.touchDelegate = self
        map.mapView.addCameraDelegate(delegate: self)
        
        return map
    }()
    
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
    
    private let animationObservable = PublishRelay<Void>()
    
    private lazy var refreshButton: RefreshButton = {
        let button = RefreshButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.rx.tap
            .observe(on: MainScheduler())
            .map { [weak self] _ -> RequestLocation? in
                guard let self = self else { return nil }
                // TODO: 애니메이션 블럭
                animationObservable.accept(())
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
            .disposed(by: self.disposeBag)
        
        return button
    }()
    
    private lazy var dimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
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
    
    private lazy var storeInformationView: StoreInformationView = {
        let view = StoreInformationView(
            summaryViewModel: summaryInformationViewModel,
            summaryInformationHeightObserver: summaryInformationHeightObserver,
            detailViewModel: detailViewModel
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.rx.panGesture()
            .when(.changed)
            .bind { [weak self] recognizer in
                guard let self = self else { return }
                let transition = recognizer.translation(in: storeInformationView)
                recognizer.setTranslation(.zero, in: storeInformationView)
                
                viewModel.action(
                    input: .storeInformationViewPanGestureChanged(
                        height: storeInformationHeightConstraint.constant - transition.y
                    )
                )
            }
            .disposed(by: disposeBag)
        
        view.rx.panGesture()
            .when(.ended)
            .bind { [weak self] recognizer in
                guard let self = self else { return }
                viewModel.action(
                    input: .storeInformationViewSwipe(
                        velocity: recognizer.velocity(in: view).y
                    )
                )
                viewModel.action(
                    input: .storeInformationViewPanGestureEnded(
                        height: storeInformationHeightConstraint.constant
                    )
                )
            }
            .disposed(by: disposeBag)
        
        view.rx.tapGesture()
            .when(.ended)
            .bind { [weak self] _ in
                guard let self = self else { return }
                viewModel.action(
                    input: .storeInformationViewTapGestureEnded
                )
            }
            .disposed(by: disposeBag)
        
        return view
    }()
    
    private let viewModel: HomeViewModel
    private let summaryInformationViewModel: SummaryViewModel
    private let detailViewModel: DetailViewModel
    private lazy var storeInformationHeightConstraint = storeInformationView.heightAnchor.constraint(equalToConstant: 0)
    private lazy var locationButtonBottomConstraint = locationButton.bottomAnchor.constraint(
        equalTo: storeInformationView.topAnchor,
        constant: -37
    )
    private lazy var refreshButtonBottomConstraint = refreshButton.bottomAnchor.constraint(
        equalTo: storeInformationView.topAnchor,
        constant: -37
    )
    private let summaryInformationHeightObserver = PublishRelay<CGFloat>()
    
    init(
        viewModel: HomeViewModel,
        summaryInformationViewModel: SummaryViewModel,
        detailViewModel: DetailViewModel
    ) {
        self.viewModel = viewModel
        self.summaryInformationViewModel = summaryInformationViewModel
        self.detailViewModel = detailViewModel
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
        unDimmedView()
        
        viewModel.action(
            input: .checkLocationAuthorization(
                status: locationManager.authorizationStatus
            )
        )
    }
    
}

private extension HomeViewController {
    
    func bind() {
        bindRefresh()
        bindSetMarker()
        bindLocationButton()
        bindLocationAuthorization()
        bindStoreInformationView()
    }
    
    func bindRefresh() {
        viewModel.refreshOutput
            .bind { [weak self] filteredStores in
                guard let self = self else { return }
                self.markers.forEach { $0.mapView = nil }
                filteredStores.forEach { filteredStore in
                    filteredStore.stores.forEach { [weak self] store in
                        self?.viewModel.action(
                            input: .setMarker(
                                store: store,
                                certificationType: filteredStore.type
                            )
                        )
                    }
                }
                storeInformationViewDismiss()
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
                // TODO: 애니메이션 종료 및 isHidden = true
                self?.refreshButton.layer.removeAllAnimations()
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
                self?.storeInformationView.setUIContents(store: store)
            }
            .disposed(by: disposeBag)
        
        viewModel.storeInformationViewHeightOutput
            .bind { [weak self] constraints in
                self?.setStoreInformationConstraints(
                    heightConstraint: constraints.heightConstraint,
                    bottomConstraint: constraints.bottomConstraint,
                    animated: constraints.animated
                )
            }
            .disposed(by: disposeBag)
        
        viewModel.detailToSummaryOutput
            .bind { [weak self] _ in
                self?.storeInformationView.changeToSummary()
                self?.unDimmedView()
                self?.viewModel.action(
                    input: .changeState(state: .summary)
                )
            }
            .disposed(by: disposeBag)
        
        viewModel.summaryToDetailOutput
            .bind { [weak self] _ in
                self?.storeInformationView.changeToDetail()
                self?.dimmedView()
                self?.viewModel.action(
                    input: .changeState(state: .detail)
                )
            }
            .disposed(by: disposeBag)
        
        // MARK: 추후 수정 필요
        summaryInformationHeightObserver.bind { [weak self] height in
            self?.viewModel.action(
                input: .setStoreInformationOriginalHeight(height: height)
            )
            self?.setStoreInformationConstraints(
                heightConstraint: height,
                bottomConstraint: -16,
                animated: true
            )
            self?.storeInformationView.changeToSummary()
            self?.unDimmedView()
            self?.viewModel.action(
                input: .changeState(state: .summary)
            )
        }
        .disposed(by: disposeBag)
    }
    
    func bindLocationAuthorization() {
        viewModel.locationAuthorizationStatusDeniedOutput
            .bind { [weak self] _ in
                guard let self = self else { return }
                present(requestLocationServiceAlert, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.locationStatusNotDeterminedOutput
            .bind { [weak self] _ in
                self?.locationManager.requestWhenInUseAuthorization()
                self?.locationButton.setImage(UIImage.locationButtonNone, for: .normal)
            }
            .disposed(by: disposeBag)
        
        viewModel.locationStatusAuthorizedWhenInUse
            .bind { [weak self] _ in
                guard let location = self?.locationManager.location else { return }
                let cameraUpdate = NMFCameraUpdate(
                    scrollTo: NMGLatLng(
                        lat: location.coordinate.latitude,
                        lng: location.coordinate.longitude
                    )
                )
                cameraUpdate.animation = .none
                self?.mapView.mapView.moveCamera(cameraUpdate)
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

}

private extension HomeViewController {
    
    func markerTouchHandler(marker: Marker) {
        marker.touchHandler = { [weak self] (_: NMFOverlay) -> Bool in
            
            if let clickedMarker = self?.clickedMarker {
                if clickedMarker == marker { return true }
                clickedMarker.deselect()
                self?.storeInformationViewDismiss()
            }
            
            self?.viewModel.action(
                input: .markerTapped(tag: marker.tag)
            )
            marker.select()
            self?.clickedMarker = marker
            
            return true
        }
    }
    
    func storeInformationViewDismiss() {
        clickedMarker?.deselect()
        clickedMarker = nil
        setStoreInformationConstraints(
            heightConstraint: 0,
            bottomConstraint: -37,
            animated: true
        )
        storeInformationView.dismissAll()
        viewModel.action(
            input: .changeState(state: .normal)
        )
    }
    
    func setStoreInformationConstraints(heightConstraint: CGFloat, bottomConstraint: CGFloat, animated: Bool = false) {
        locationButtonBottomConstraint.constant = bottomConstraint
        refreshButtonBottomConstraint.constant = bottomConstraint
        storeInformationHeightConstraint.constant = heightConstraint
        if animated {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.layoutIfNeeded()
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
    
}

private extension HomeViewController {
    
    func addUIComponents() {
        view.addSubview(mapView)
        mapView.addSubview(locationButton)
        mapView.addSubview(filterButtonStackView)
        mapView.addSubview(refreshButton)
        mapView.addSubview(dimView)
        mapView.addSubview(storeInformationView)
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
            filterButtonStackView.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            filterButtonStackView.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            refreshButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            refreshButtonBottomConstraint
        ])
        
        NSLayoutConstraint.activate([
            storeInformationView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 0),
            storeInformationView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: 0),
            storeInformationView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 0),
            storeInformationHeightConstraint
        ])
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
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        if reason == NMFMapChangedByDeveloper {
            mapView.positionMode = .direction
            
            viewModel.action(input: 
                    .checkLocationAuthorizationWhenCameraDidChange(
                        status: locationManager.authorizationStatus
                    )
            )
            viewModel.action(
                input: .refresh(
                    requestLocation: makeRequestLocation(projection: mapView.projection)
                )
            )
//            refreshButton.isHidden = true
            // TODO: 로딩 애니메이션 시작
            animationObservable.accept(())
        }
    }
    
}

extension HomeViewController: NMFMapViewTouchDelegate {
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        storeInformationViewDismiss()
        unDimmedView()
    }
    
}
