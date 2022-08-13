//
//  UIImageView.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/12.
//

import UIKit

extension UIImageView: ExtensionSupport {}
extension Extension where Base == UIImageView {
    @discardableResult
    func setImage(_ url: String) -> URLSessionDataTask? {
        if let cachedImage = ImageCacheManager.shared.retrive(forKey: url) {
            self.base.image = cachedImage
            return nil
        }
        
        guard let imageUrl = URL(string: url) else {
            self.base.image = UIImage()
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: imageUrl) { data, _, error in
            if let _ = error {
                DispatchQueue.main.async {
                    self.base.image = UIImage()
                }
                return
            }
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    ImageCacheManager.shared.set(object: image, forKey: url)
                    self.base.image = image
                }
            }
        }
        task.resume()
        
        return task
    }
}
