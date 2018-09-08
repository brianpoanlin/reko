//
//  QRData.swift
//  QRCode Generator
//
//  Created by Vitali Kurlovich on 11/9/17.
//



class QRData {
	
	enum QRMode : Int {
		case MODE_NUMBER = 1
		case MODE_ALPHA_NUM = 2
		case MODE_8BIT_BYTE = 4
		case MODE_KANJI = 8
	}
	
	let mode:QRMode;
	let data:String;
	
	var lenght : Int {
		get {
			return self.data.count
		}
	}
	
	init(_ mode:QRMode, _ data:String ) {
		self.mode = mode;
		self.data = data;
	}
	
	func write(_ buffer: inout QRBitBuffer ) {
		
	}
	
	
	public func getLengthInBits(_ type:Int) -> Int {
		
		if (1 <= type && type < 10) {
			
			// 1 - 9
			
			switch mode  {
			case .MODE_NUMBER     : return 10;
			case .MODE_ALPHA_NUM   : return 9;
			case .MODE_8BIT_BYTE  : return 8;
			case .MODE_KANJI      : return 8;

			}
			
		} else if type < 27 {
			
			// 10 - 26
			
			switch mode {
			case .MODE_NUMBER     : return 12;
			case .MODE_ALPHA_NUM   : return 11;
			case .MODE_8BIT_BYTE  : return 16;
			case .MODE_KANJI      : return 10;
				
			}
			
		} else if type < 41 {
			
			// 27 - 40
			
			switch mode  {
			case .MODE_NUMBER     : return 14;
			case .MODE_ALPHA_NUM  : return 13;
			case .MODE_8BIT_BYTE  : return 16;
			case .MODE_KANJI      : return 12;
				
			}
		}
		
		return 0
	}
	
	
}
