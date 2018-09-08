//
//  QR8BitByte.swift
//  QRCode Generator
//
//  Created by Vitali Kurlovich on 11/9/17.
//

import Foundation

final class QR8BitByte: QRData {
	
	private let bdata:Data
	
	init(_ data:String) {
		bdata = data.data(using: .shiftJIS, allowLossyConversion: true)!
		super .init(QRMode.MODE_8BIT_BYTE, data)
	}
	
	init(_ data:Data) {
		bdata = data
		super .init(QRMode.MODE_8BIT_BYTE, "")
	}
	
	override var lenght: Int {
		get {
			return bdata.count;
		}
	}
	
	override func write(_ buffer: inout QRBitBuffer ) {

		for d in bdata {
			buffer.put(Int(d), 8);
		}
	}
}
