//
//  MockImage.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/27/24.
//

import Foundation

// TODO: MockImage 삭제
final class MockImage {
    
    lazy var bundle = Bundle(for: type(of: self))
    
    func getImageURL() -> Data {
        guard let imageURL = bundle.url(forResource: "MockImage", withExtension: "jpeg"),
              let data = try? Data(contentsOf: imageURL) else { return Data() }
        
        return data
    }
    
}
