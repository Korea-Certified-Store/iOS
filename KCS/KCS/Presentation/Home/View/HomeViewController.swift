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
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        
        return manager
    }()
    
    private let disposeBag = DisposeBag()
    
    private lazy var locationButton: NMFLocationButton = {
        let locationButton = NMFLocationButton()
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.rx.controlEvent(.touchCancel)
            .bind { [weak self] _ in
                self?.checkUserDeviceLocationServiceAuthorization()
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

    private lazy var mapView: NMFNaverMapView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUIComponents()
        configureConstraints()
        checkUserDeviceLocationServiceAuthorization()
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // TODO: Location update 완료시 동작 구현
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: Location update 실패시 동작 구현
    }
    
    func checkUserDeviceLocationServiceAuthorization() {
        Observable
            .just(())
            .observe(on: SerialDispatchQueueScheduler(qos: .background))
            .subscribe { [weak self] _ in
                guard CLLocationManager.locationServicesEnabled() else {
                    self?.showRequestLocationServiceAlert()
                    return
                }
            }
            .disposed(by: disposeBag)
        let authorizationStatus: CLAuthorizationStatus = locationManager.authorizationStatus
        checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showRequestLocationServiceAlert()
        default:
            break
        }
    }
    
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(
            title: "위치 정보 이용",
            message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.",
            preferredStyle: .alert
        )
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default) { _ in
            print("취소")
        }
        
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true)
    }
    
}
