//
//  ExtUIImage.swift
//  FightHunger-Organisasi
//
//  Created by Antonius George on 23/01/19.
//  Copyright © 2019 FightHunger. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	
	func setCardView(view : UIView){
		
		view.layer.cornerRadius = 5.0
		view.layer.borderColor  =  UIColor.clear.cgColor
		view.layer.borderWidth = 5.0
		view.layer.shadowOpacity = 0.5
		view.layer.shadowColor =  UIColor.lightGray.cgColor
		view.layer.shadowRadius = 5.0
		view.layer.shadowOffset = CGSize(width:5, height: 5)
		view.layer.masksToBounds = true
		
	}
}

extension UIViewController {
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
}

extension CALayer {
	func applySketchShadow(
		color: UIColor = .black,
		alpha: Float = 0.5,
		x: CGFloat = 0,
		y: CGFloat = 2,
		blur: CGFloat = 4,
		spread: CGFloat = 0)
	{
		shadowColor = color.cgColor
		shadowOpacity = alpha
		shadowOffset = CGSize(width: x, height: y)
		shadowRadius = blur / 2.0
		if spread == 0 {
			shadowPath = nil
		} else {
			let dx = -spread
			let rect = bounds.insetBy(dx: dx, dy: dx)
			shadowPath = UIBezierPath(rect: rect).cgPath
		}
	}
}



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
	
	public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
		let rect = CGRect(origin: .zero, size: size)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		guard let cgImage = image?.cgImage else { return nil }
		self.init(cgImage: cgImage)
	}
	
	
}
