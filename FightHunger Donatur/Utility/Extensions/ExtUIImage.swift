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
	
	enum JPEGQuality: CGFloat {
		case lowest  = 0
		case low     = 0.25
		case medium  = 0.5
		case high    = 0.75
		case highest = 1
	}
	
	/// Returns the data for the specified image in JPEG format.
	/// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
	/// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
	func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
		return jpegData(compressionQuality: jpegQuality.rawValue)
	}
	
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
