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
        button.rx.tap
            .scan(false) { [weak self] (lastState, _) in
                guard let self = self else { return lastState }
                if lastState {
                    guard let lastIndex = activatedFilter.lastIndex(of: .goodPrice) else { return lastState }
                    activatedFilter.remove(at: lastIndex)
                } else {
                    activatedFilter.append(.goodPrice)
                }
                viewModel.fetchFilteredStores(filters: getActivatedTypes())
                return !lastState
            }
            .bind(to: button.rx.isSelected)
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var exemplaryFilterButton: FilterButton = {
        let button = FilterButton(title: "모범 음식점", color: UIColor.exemplary)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rx.tap
            .scan(false) { [weak self] (lastState, _) in
                guard let self = self else { return lastState }
                if lastState {
                    guard let lastIndex = activatedFilter.lastIndex(of: .exemplary) else { return lastState }
                    activatedFilter.remove(at: lastIndex)
                } else {
                    activatedFilter.append(.exemplary)
                }
                viewModel.fetchFilteredStores(filters: getActivatedTypes())
                return !lastState
            }
            .bind(to: button.rx.isSelected)
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var safeFilterButton: FilterButton = {
        let button = FilterButton(title: "안심 식당", color: UIColor.safe)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rx.tap
            .scan(false) { [weak self] (lastState, _) in
                guard let self = self else { return lastState }
                if lastState {
                    guard let lastIndex = activatedFilter.lastIndex(of: .safe) else { return lastState }
                    activatedFilter.remove(at: lastIndex)
                } else {
                    activatedFilter.append(.safe)
                }
                viewModel.fetchFilteredStores(filters: getActivatedTypes())
                return !lastState
            }
            .bind(to: button.rx.isSelected)
            .disposed(by: disposeBag)
        
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

    private lazy var mapView: NMFNaverMapView = {
        let map = NMFNaverMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showZoomControls = false
        map.showCompass = false
        map.showScaleBar = false
        map.showIndoorLevelPicker = false
        map.showLocationButton = false
        map.mapView.logoAlign = .rightBottom
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
    
    private lazy var refreshButton: RefreshButton = {
        let button = RefreshButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
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
                    filters: getActivatedTypes()
                )
            }
            .disposed(by: self.disposeBag)
        
        return button
    }()
    
    private var activatedFilter: [CertificationType] = []
    
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
            .bind { [weak self] filteredStores in
                guard let self = self else { return }
                self.refreshButton.isHidden = true
                self.markers.forEach { $0.mapView = nil }
                filteredStores.forEach { filteredStore in
                    filteredStore.stores.forEach {
                        let location = $0.location.toMapLocation()
                        let marker = Marker(type: filteredStore.type, position: location)
                        marker.mapView = self.mapView.mapView
                        self.markers.append(marker)
                    }
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    func getActivatedTypes() -> [CertificationType] {
        if activatedFilter.isEmpty {
            return [.safe, .exemplary, .goodPrice]
        }
        
        return activatedFilter
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
            locationButton.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            locationButton.widthAnchor.constraint(equalToConstant: 48),
            locationButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            filterButtonStackView.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            filterButtonStackView.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            refreshButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            refreshButton.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -16)
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
            let startPoint = mapView.projection.latlng(from: CGPoint(x: 0, y: 0))
            let endPoint = mapView.projection.latlng(from: CGPoint(x: view.frame.width, y: view.frame.height))
            viewModel.refresh(
                northWestLocation: Location(
                    longitude: startPoint.lng,
                    latitude: startPoint.lat
                ),
                southEastLocation: Location(
                    longitude: endPoint.lng,
                    latitude: endPoint.lat
                ),
                filters: getActivatedTypes()
            )
        }
    }
    
}
