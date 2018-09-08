//
//  QRKanji.swift
//  QRCode Generator
//
//  Created by Vitali Kurlovich on 11/9/17.
//



final class QRKanji: QRData {
	
	init(_ data:String) {
		super .init(QRMode.MODE_KANJI, data)
	}
	
	override func write(_ buffer: inout QRBitBuffer) {
		
		var i = 0;
		let bdata = data.data(using: .shiftJIS, allowLossyConversion: true)!
		
		while i + 1 < bdata.count {
			
			var c =  ( (UInt16(bdata[i]) & 0x00ff) << 8) | (UInt16(bdata[i + 1] & 0x00ff));
			if (0x8140 <= c && c <= 0x9FFC) {
				c -= 0x8140;
			} else if (0xE040 <= c && c <= 0xEBBF) {
				c -= 0xC140;
			} else {
				
			}
			c =  ((c >> 8) & 0x00ff) * 0xC0 +  (c & 0x00ff);
			buffer.put(Int(c), 13);
			
			i += 2;
		}
		
		if (i < bdata.count) {
			//throw new IllegalArgumentException("illegal char at " + (i + 1) );
		}

		
	}
}
