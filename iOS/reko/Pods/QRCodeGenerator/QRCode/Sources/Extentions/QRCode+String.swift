//
//  QRCode+String.swift
//  QRCode
//
//  Created by Vitali Kurlovich on 11/14/17.
//  Copyright © 2017 Vitali Kurlovich. All rights reserved.
//

public extension String {
	
	public init(_ qr:QRCode) {
		self.init(qr, border:true)
	}
	
	public init(_ qr:QRCode, border:Bool) {
		
		var str = ""
		
		if (border) {
			for _ in 0..<(qr.size+2) {
				str += "⬜"
			}
			str += "\n"
		}
		
		for (index, row) in qr.modules.enumerated() {
			if (border) {
				str += "⬜"
			}
			for col in row {
				if (col) {
					str += "⬛"
				} else {
					str += "⬜"
				}
			}
			
			if (border) {
				str += "⬜"
			}
			
			if (index < qr.modules.count-1) {
				str += "\n"
			}
		}
		
		if (border) {
			str += "\n"
			for _ in 0..<(qr.size+2) {
				str += "⬜"
			}
		}
		
		self.init(str)
	}
}
