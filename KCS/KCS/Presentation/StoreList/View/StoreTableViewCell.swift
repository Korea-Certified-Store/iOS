//
//  StoreTableViewCell.swift
//  KCS
//
//  Created by 조성민 on 1/31/24.
//

import UIKit

final class StoreTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension StoreTableViewCell {
    
    func setUIContents(store: Store) {
        
    }
    
}
