//
//  GetOpenClosedUseCase.swift
//  KCS
//
//  Created by 김영현 on 1/18/24.
//

import Foundation

protocol GetOpenClosedUseCase {
    
    func execute(
        openingHours: [RegularOpeningHours],
        today: Date
    ) throws -> OpenClosedContent
    
}
