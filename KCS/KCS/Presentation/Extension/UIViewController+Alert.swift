//
//  UIViewController+Alert.swift
//  KCS
//
//  Created by 조성민 on 2/3/24.
//

import UIKit

extension UIViewController {
    
    func presentErrorAlert(error: ErrorAlertMessage) {
        let alertController = UIAlertController(title: nil, message: error.errorDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default))
        if let presentController = presentedViewController {
            presentController.presentErrorAlert(error: error)
        } else if !(self is UIAlertController) {
            present(alertController, animated: true)
        }
    }
    
    func presentLocationAlert() {
        let requestLocationServiceAlert: UIAlertController = {
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
        
        if let presentController = presentedViewController {
            presentController.presentLocationAlert()
        } else {
            present(requestLocationServiceAlert, animated: true)
        }
    }
    
    func showToast(message: String) {
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.backgroundColor = .black.withAlphaComponent(0.6)
        toastLabel.textColor = .white
        toastLabel.font = .pretendard(size: 14, weight: .medium)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 0
        toastLabel.setLayerCorner(cornerRadius: 12)
        toastLabel.clipsToBounds = true
        view.addSubview(toastLabel)
        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            toastLabel.widthAnchor.constraint(equalToConstant: 150),
            toastLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                toastLabel.alpha = 1.0
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.8,
                    delay: 1.4,
                    options: .curveEaseOut,
                    animations: {
                        toastLabel.alpha = 0.0
                    }, completion: { _ in
                        toastLabel.removeFromSuperview()
                    }
                )
            }
        )
    }
    
}
