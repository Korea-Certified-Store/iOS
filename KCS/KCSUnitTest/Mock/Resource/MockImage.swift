//
//  MockImage.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/26/24.
//

import Foundation

struct MockImage {
    
    func getImageData(url: String) -> Data {
        do {
            guard let image = Bundle.main.url(forResource: url, withExtension: ".jpeg") else { return Data() }
            return try Data(contentsOf: image)
        } catch {
            return Data()
        }
    }
    
}
