//
//  FetchStores.swift
//  KCS
//
//  Created by 김영현 on 2/4/24.
//

import Foundation

struct FetchStores {
    
    let fetchCountContent: FetchCountContent
    let stores: [Store]
    
}

struct FetchCountContent {
    
    var maxFetchCount: Int = 1
    var fetchCount: Int = 1
    
}
