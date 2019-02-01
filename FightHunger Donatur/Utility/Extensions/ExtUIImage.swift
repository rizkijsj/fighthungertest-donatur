//
//  ExtUIImage.swift
//  FightHunger-Organisasi
//
//  Created by Antonius George on 23/01/19.
//  Copyright © 2019 FightHunger. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
	
	/// Usage
	/// imageView.image = UIImage(url: URL(string: "some_url.png"))
	convenience init?(url: URL?) {
		guard let url = url else { return nil }
		
		do {
			let data = try Data(contentsOf: url)
			self.init(data: data)
		} catch {
			print("Cannot load image from url: \(url) with error: \(error)")
			return nil
		}
	}
	
	
	
	func isEqual(to image: UIImage) -> Bool {
		return isEqual(image)
	}
	
	
	
	
}
