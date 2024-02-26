//
//  ImageCache.swift
//  KCS
//
//  Created by 조성민 on 1/19/24.
//

import Foundation

final class ImageCache {
    
    private let cache: NSCache<NSURL, NSData>
    
    init(cache: NSCache<NSURL, NSData>) {
        self.cache = cache
    }
    
    func getImageData(for key: NSURL) -> NSData? {
        if let cachedImageData = cache.object(forKey: key as NSURL) {
            return cachedImageData
        }
        
        return nil
    }
    
    func setImageData(_ data: NSData, for key: NSURL) {
        cache.setObject(data, forKey: key as NSURL)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }

}
