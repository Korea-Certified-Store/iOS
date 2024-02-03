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
    
}
