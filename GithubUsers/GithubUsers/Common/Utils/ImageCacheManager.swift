//
//  ImageCacheManager.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/12.
//

import UIKit

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func set(object: UIImage, forKey key: String) {
        cache.setObject(object, forKey: key as NSString)
    }
    
    func retrieve(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
}
