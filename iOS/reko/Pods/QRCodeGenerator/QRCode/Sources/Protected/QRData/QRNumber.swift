//
//  QRNumber.swift
//  QRCode Generator
//
//  Created by Vitali Kurlovich on 11/9/17.
//


final class QRNumber: QRData {
	
	init(_ data:String) {
		super .init(QRMode.MODE_NUMBER, data)
	}
	
	override func write(_ buffer: inout QRBitBuffer) {
		let number = self.data
		
		var i = 0
		while (i + 2) < number.count {
			let from = String.Index(encodedOffset:i)
			let to = String.Index(encodedOffset:(i+3))
			let num = Int(number[from..<to])!
			buffer.put(num, 10);
			i += 3;
		}
		
		if i < data.count {
			if data.count - i == 1 {
				let from = String.Index(encodedOffset:i)
				let to = String.Index(encodedOffset:(i+1))
				let num = Int(number[from..<to])!
				buffer.put(num, 4);
			} else if data.count - i == 2 {
				let from = String.Index(encodedOffset:i)
				let to = String.Index(encodedOffset:(i+2))
				let num = Int(number[from..<to])!
				buffer.put(num, 7);
			}
		}
	}
	
}
