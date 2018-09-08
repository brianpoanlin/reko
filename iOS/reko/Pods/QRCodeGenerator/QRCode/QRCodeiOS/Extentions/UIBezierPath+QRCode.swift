//
//  QRCode+UIPath.swift
//  QRCode
//
//  Created by Vitali Kurlovich on 11/14/17.
//  Copyright © 2017 Vitali Kurlovich. All rights reserved.
//

import UIKit

public extension UIBezierPath {
	
	public convenience init(_ qr:QRCode) {
		self.init()
	
		let size = qr.size
		for row in 0..<size {
			for col in 0..<size {
				if (qr[row, col]) {
					let rect = CGRect(x:col, y:row, width:1, height:1)
					let elem = UIBezierPath(roundedRect:rect, cornerRadius:0)
					append(elem)
				}
			}
		}
	}
	
}


