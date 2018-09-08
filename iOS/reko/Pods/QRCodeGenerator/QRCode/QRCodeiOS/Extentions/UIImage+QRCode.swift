//
//  UIImage+QRCode.swift
//  QRCode
//
//  Created by Vitali Kurlovich on 11/14/17.
//  Copyright © 2017 Vitali Kurlovich. All rights reserved.
//

import UIKit


public extension UIImage {
	
	public class func qrCodeImage(_ qr:QRCode, _ size:CGSize, _ color:UIColor = UIColor.black, _ border:CGFloat = 0, _ background:UIColor = UIColor.clear) -> UIImage? {
		
		let bezier = UIBezierPath(qr)
		
		let bounds = CGRect(x:border, y:border, width:size.width - 2*border, height:size.height - 2*border)
		
		let transform = CGAffineTransform.transformForMode(contentMode: UIViewContentMode.scaleAspectFit, bounds: bounds, contentBounds: bezier.bounds)
		
		bezier.apply(transform)
		bezier.apply(CGAffineTransform(translationX: border, y: border))
		
		UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
		
		if (background != UIColor.clear) {
			let rect = CGRect(x:0, y:0, width:size.width, height:size.height)
			let bg = UIBezierPath(roundedRect:rect, cornerRadius:0)
			background.setFill()
			bg.fill()
		}
		
		color.setFill()
		bezier.fill()
		let image =	UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image;
	}
}
