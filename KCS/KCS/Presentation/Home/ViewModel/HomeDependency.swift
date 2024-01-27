//
//  HomeDependency.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import RxSwift

enum HomeViewState {
    
    case normal
    case summary
    case detail
    
}

struct HomeDependency {
    
    let disposeBag = DisposeBag()
    var state: HomeViewState = .normal
    var storeInformationOriginalHeight: CGFloat = 0
    var activatedFilter: [CertificationType] = []
    
}
