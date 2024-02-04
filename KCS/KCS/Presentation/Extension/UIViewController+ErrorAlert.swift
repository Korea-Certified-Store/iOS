//
//  UIViewController+ErrorAlert.swift
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
        } else {
            present(alertController, animated: true)
        }
        
    }
    
}
