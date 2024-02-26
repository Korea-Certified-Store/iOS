//
//  FetchImageUseCase.swift
//  KCS
//
//  Created by 조성민 on 1/19/24.
//

import RxSwift

protocol FetchImageUseCase {
    
    var repository: FetchImageRepository { get }
    
    init(repository: FetchImageRepository)
    
    func execute(url: String) -> Observable<Data>
    
}
