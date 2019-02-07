//
//  ImageService.swift
//  PageSpareFood1
//
//  Created by Rizki Adrian Saputra on 17/10/18.
//  Copyright © 2018 Nelis Lasta. All rights reserved.
//

import Foundation
import UIKit

class ImageService {
    
    static let cache = NSCache<NSString, UIImage>()
    
    static func downloadImage(withURL url:URL, completion: @escaping (_ image:UIImage?, _ url:URL,_ fromCache:Bool)->()) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, responseURL, error in
            var downloadedImage:UIImage?
            
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            if downloadedImage != nil {
                cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage, url, false)
            }
            
        }
        
        dataTask.resume()
    }
    
	static func getImage(withURL url:URL, completion: @escaping (_ image:UIImage?, _ url:URL, _ fromCache:Bool)->()) {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image, url, true)
        } else {
            downloadImage(withURL: url, completion: completion)
        }
    }
}
