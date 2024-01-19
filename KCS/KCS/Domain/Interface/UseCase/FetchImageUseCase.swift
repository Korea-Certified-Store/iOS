//
//  FetchImageUseCase.swift
//  KCS
//
//  Created by 조성민 on 1/19/24.
//

import RxSwift

protocol FetchImageUseCase {
    
    var repository: ImageRepository { get }
    
    init(repository: ImageRepository)
    
    func execute(url: String) -> Observable<Data>
    
}
