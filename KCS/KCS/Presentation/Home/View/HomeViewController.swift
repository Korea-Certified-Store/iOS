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
        let button = FilterButton(title: "착한 가격 업소", color: UIColor.goodPrice)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let exemplaryFilterButton: FilterButton = {
        let button = FilterButton(title: "모범 음식점", color: UIColor.exemplary)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let safeFilterButton: FilterButton = {
        let button = FilterButton(title: "안심 식당", color: UIColor.safe)
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    private var summaryInformationView: SummaryInformationView = {
        let view = SummaryInformationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var locationBottomConstraint = locationButton.bottomAnchor.constraint(equalTo: summaryInformationView.topAnchor, constant: -29)
    private lazy var refreshBottomConstraint = refreshButton.bottomAnchor.constraint(equalTo: summaryInformationView.topAnchor, constant: -29)
    private lazy var summaryInfoBottomConstraint = summaryInformationView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 224)
    
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
//        button.isHidden = true
        button.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                let startPoint = mapView.mapView.projection.latlng(from: CGPoint(x: 0, y: 0))
                let endPoint = mapView.mapView.projection.latlng(from: CGPoint(x: view.frame.width, y: view.frame.height))
                viewModel.refresh(
                    northWestLocation: Location(
                        longitude: startPoint.lng,
                        latitude: startPoint.lat
                    ),
                    southEastLocation: Location(
                        longitude: endPoint.lng,
                        latitude: endPoint.lat
                    ),
                    types: getActivatedTypes()
                )
            }
            .disposed(by: self.disposeBag)
        
        return button
    }()
    
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
        viewModel.refreshComplete
            .bind { [weak self] loadedStores in
                guard let self = self else { return }
                self.markers.forEach { $0.mapView = nil }
                loadedStores.stores.forEach {
                    let location = $0.location
                    guard let lastType = $0.certificationTypes.filter({ self.getActivatedTypes().contains($0) }).last else { return }
                    let marker = Marker(certificationType: lastType, position: location.toMapLocation())
                    marker.tag = UInt($0.id)
                    self.markerTouchHandler(marker: marker)
                    marker.mapView = self.mapView.mapView
                    self.markers.append(marker)
                }
                markerCancel()
            }
            .disposed(by: disposeBag)
        
        viewModel.getStoreInfoComplete
            .bind { [weak self] store in
                guard let self = self else { return }
                guard let store = store else { return }
                markerClicked(store: store)
            }
            .disposed(by: disposeBag)
    }
    
    func getActivatedTypes() -> [CertificationType] {
        var types: [CertificationType] = []
        
        if goodPriceFilterButton.isSelected {
            types.append(.goodPrice)
        }
        if exemplaryFilterButton.isSelected {
            types.append(.exemplary)
        }
        if safeFilterButton.isSelected {
            types.append(.safe)
        }
        
        return types
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
            marker.isSelected = !marker.isSelected
            if marker.isSelected {
                viewModel.markerTapped(tag: marker.tag)
            }
            clickedMarker = marker
            
            return true
        }
    }
    
    func markerClicked(store: Store) {
        summaryInfoBottomConstraint.constant = 0
        locationBottomConstraint.constant = -8
        refreshBottomConstraint.constant = -8
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func markerCancel() {
        summaryInfoBottomConstraint.constant = 224
        locationBottomConstraint.constant = -29
        refreshBottomConstraint.constant = -29
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
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
        mapView.addSubview(summaryInformationView)
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
            summaryInformationView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 0),
            summaryInformationView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: 0),
            summaryInformationView.heightAnchor.constraint(equalToConstant: 224),
            summaryInfoBottomConstraint
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
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        if reason == NMFMapChangedByDeveloper {
            mapView.positionMode = .direction
            locationButton.setImage(UIImage.locationButtonNormal, for: .normal)
        }
    }
    
}

extension HomeViewController: NMFMapViewTouchDelegate {
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        clickedMarker?.isSelected = false
        clickedMarker = nil
        markerCancel()
    }
    
}
