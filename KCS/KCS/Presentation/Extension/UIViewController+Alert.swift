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
    
}
