//
//  MockImage.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/27/24.
//

import Foundation

final class MockImage {
    
    lazy var bundle = Bundle(for: type(of: self))
    
    func getImageURL(imageString: String) -> Data {
        guard let imageURL = bundle.url(forResource: imageString, withExtension: "jpeg") else { return Data() }
        
        return try! Data(contentsOf: imageURL)
    }
    
}
