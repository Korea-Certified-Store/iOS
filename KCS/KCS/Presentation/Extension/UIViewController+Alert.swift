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
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        if let presentController = presentedViewController {
            presentController.presentLocationAlert()
        } else {
            present(requestLocationServiceAlert, animated: true)
        }
    }
    
    func showToast(message: String) {
        let toastView = makeToastView(message: message)
        
        let windows = UIApplication.shared.connectedScenes
        let scene = windows.first { $0.activationState == .foregroundActive }
        if let windowScene = scene as? UIWindowScene, let windowView = windowScene.windows.first {
            windowView.addSubview(toastView)
            NSLayoutConstraint.activate([
                toastView.centerXAnchor.constraint(equalTo: windowView.centerXAnchor),
                toastView.bottomAnchor.constraint(equalTo: windowView.bottomAnchor, constant: -82)
            ])
        }
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                toastView.alpha = 1.0
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.6,
                    delay: 2.0,
                    options: .curveEaseOut,
                    animations: {
                        toastView.alpha = 0.0
                    }, completion: { _ in
                        toastView.removeFromSuperview()
                    }
                )
            }
        )
    }
    
    func makeToastView(message: String) -> UIStackView {
        let toastImageView = UIImageView(
            image: SystemImage.toast?.withTintColor(.white, renderingMode: .alwaysOriginal)
        )
        toastImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let toastLabel = UILabel()
        toastLabel.backgroundColor = .clear
        toastLabel.textColor = .white
        toastLabel.font = .pretendard(size: 14, weight: .regular)
        toastLabel.text = message
        toastLabel.clipsToBounds = true
        
        let toastView = UIStackView()
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.backgroundColor = .black.withAlphaComponent(0.65)
        toastView.alpha = 0
        toastView.setLayerCorner(cornerRadius: 20)
        toastView.isLayoutMarginsRelativeArrangement = true
        toastView.layoutMargins = UIEdgeInsets(top: 11, left: 15, bottom: 10, right: 13)
        toastView.spacing = 8
        toastView.alignment = .center
        toastView.distribution = .fill
        
        toastView.addArrangedSubview(toastImageView)
        toastView.addArrangedSubview(toastLabel)
        
        NSLayoutConstraint.activate([
            toastImageView.widthAnchor.constraint(equalToConstant: 16),
            toastImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        return toastView
    }
    
}
