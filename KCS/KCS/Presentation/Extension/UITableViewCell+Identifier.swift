//
//  UITableViewCell+Identifier.swift
//  KCS
//
//  Created by 조성민 on 1/31/24.
//

import UIKit

extension UITableViewCell {

    static var identifier: String {
        return String(describing: self)
    }

}

extension UITableViewHeaderFooterView {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
