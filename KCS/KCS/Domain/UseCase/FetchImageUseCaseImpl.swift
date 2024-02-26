//
//  FetchImageUseCaseImpl.swift
//  KCS
//
//  Created by 조성민 on 1/19/24.
//

import RxSwift

struct FetchImageUseCaseImpl: FetchImageUseCase {
    
    let repository: FetchImageRepository
    
    func execute(url: String) -> Observable<Data> {
        return repository.fetchImage(url: url)
    }
    
}
