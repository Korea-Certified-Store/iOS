//
//  GetStoreInformationUseCase.swift
//  KCS
//
//  Created by 김영현 on 1/17/24.
//

import Foundation

protocol GetStoreInformationUseCase {
    
    var repository: GetStoreInformationRepository { get }
    
    init(repository: GetStoreInformationRepository)
    
    func execute(tag: UInt) throws -> Store
    
}
