//
//  HomeDependency.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import RxSwift

struct HomeDependency {
    
    let disposeBag = DisposeBag()
    var activatedFilter: [CertificationType] = []
    var fetchCount: Int = 1
    var maxFetchCount: Int = 1
    var isRefreshReady: Bool = true
    
    mutating func resetFetchCount() {
        fetchCount = 1
    }
    
}
