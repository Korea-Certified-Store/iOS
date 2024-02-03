//
//  ImageRepositoryError.swift
//  KCS
//
//  Created by 조성민 on 1/19/24.
//

import Foundation

enum ImageRepositoryError: Error, LocalizedError {
    
    case noImageData
    
    var errorDescription: String {
        switch self {
        case .noImageData:
            return "ImageData가 없습니다."
        }
    }
}
