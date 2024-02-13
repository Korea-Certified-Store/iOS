//
//  RecentHistoryTableViewCellDelegate.swift
//  KCS
//
//  Created by 김영현 on 2/13/24.
//

import Foundation

protocol RecentHistoryTableViewCellDelegate: AnyObject {
    
    func removeKeywordButtonTapped(index: Int)
    
}
