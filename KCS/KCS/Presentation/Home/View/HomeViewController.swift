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
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        
        return locationManager
    }()
    
    private lazy var locationButton: NMFLocationButton = {
        let locationButton = NMFLocationButton()
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.rx.controlEvent(.touchCancel)
            .bind { [weak self] _ in
                self?.checkLocationService()
                switch locationButton.mapView?.positionMode {
                case .direction:
                    locationButton.mapView?.positionMode = .direction
                case .compass:
                    locationButton.mapView?.positionMode = .compass
                default:
                    locationButton.mapView?.positionMode = .normal
                }
            }
            .disposed(by: self.disposeBag)
        locationButton.mapView = mapView.mapView

        return locationButton
    }()

    private var mapView: NMFNaverMapView = {
        let map = NMFNaverMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showZoomControls = false
        map.showCompass = false
        map.showScaleBar = false
        map.showIndoorLevelPicker = false
        map.showLocationButton = false
        map.mapView.logoAlign = .rightBottom
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUIComponents()
        configureConstraints()
        checkUserCurrentLocationAuthorization()
    }

}

private extension HomeViewController {
    
    func checkUserCurrentLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            let cameraUpdate = NMFCameraUpdate(scrollTo:
                                                NMGLatLng(
                                                    lat: locationManager.location?.coordinate.latitude ?? 0,
                                                    lng: locationManager.location?.coordinate.longitude ?? 0
                                                ))
            cameraUpdate.animation = .easeIn
            mapView.mapView.moveCamera(cameraUpdate)
            mapView.mapView.positionMode = .normal
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
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            locationButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            locationButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20)
        ])
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserCurrentLocationAuthorization()
    }
}
