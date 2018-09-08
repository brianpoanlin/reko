//
//  QRUtil.swift
//  QRCode Generator
//
//  Created by Vitali Kurlovich on 11/9/17.
//


struct QRUtil {
	
	enum QRMaskPattern : Int {
		//000
		case PATTERN000 = 0
		//001
		case PATTERN001 = 1
		//010
		case PATTERN010 = 2
		//011
		case PATTERN011 = 3
		//100
		case PATTERN100 = 4
		//101
		case PATTERN101 = 5
		//110
		case PATTERN110 = 6
		//111
		case PATTERN111 = 7
		
		static let allPatterns = [QRMaskPattern.PATTERN000, QRMaskPattern.PATTERN001, QRMaskPattern.PATTERN010, QRMaskPattern.PATTERN011, QRMaskPattern.PATTERN100, QRMaskPattern.PATTERN101, QRMaskPattern.PATTERN110 ,QRMaskPattern.PATTERN111]
	}
	
	static func getLostPoint(_ qrCode:QRCodeProcessor) -> Int {
		
		let moduleCount = qrCode.moduleCount;
		
		var lostPoint = 0;
		
		// LEVEL1
		
		for row in 0..<moduleCount {
			
			for col in 0..<moduleCount {
				
				var sameCount = 0;
				let dark = qrCode.isDark(row, col);
				
				for r in -1...1 {
					
					if row + r < 0 || moduleCount <= row + r {
						continue;
					}
					
					for c in -1...1  {
						
						if col + c < 0 || moduleCount <= col + c {
							continue;
						}
						
						if (r == 0 && c == 0) {
							continue;
						}
						
						if (dark == qrCode.isDark(row + r, col + c) ) {
							sameCount += 1
						}
					}
				}
				
				if (sameCount > 5) {
					lostPoint += (3 + sameCount - 5);
				}
			}
		}
		
		// LEVEL2
		
		for row in 0..<(moduleCount - 1) {
			for col in 0..<(moduleCount - 1) {
				var count = 0;
				count += (qrCode.isDark(row,     col) ? 1 : 0);
				count += (qrCode.isDark(row + 1, col) ? 1 : 0);
				count += (qrCode.isDark(row, col + 1) ? 1 : 0);
				count += (qrCode.isDark(row + 1, col + 1) ? 1 : 0);
				
				if (count == 0 || count == 4) {
					lostPoint += 3;
				}
			}
		}
		
		// LEVEL3
		
		for  row in 0..<moduleCount {
			for  col in 0..<(moduleCount - 6) {
				if (qrCode.isDark(row, col)
					&& !qrCode.isDark(row, col + 1)
					&&  qrCode.isDark(row, col + 2)
					&&  qrCode.isDark(row, col + 3)
					&&  qrCode.isDark(row, col + 4)
					&& !qrCode.isDark(row, col + 5)
					&&  qrCode.isDark(row, col + 6) ) {
					lostPoint += 40;
				}
			}
		}
		
		for col in 0..<moduleCount {
			for row in 0..<(moduleCount - 6) {
				if (qrCode.isDark(row, col)
					&& !qrCode.isDark(row + 1, col)
					&&  qrCode.isDark(row + 2, col)
					&&  qrCode.isDark(row + 3, col)
					&&  qrCode.isDark(row + 4, col)
					&& !qrCode.isDark(row + 5, col)
					&&  qrCode.isDark(row + 6, col) ) {
					lostPoint += 40;
				}
			}
		}
		
		// LEVEL4
		
		var darkCount = 0;
		
		for col in 0..<moduleCount {
			for row in 0..<moduleCount {
				if (qrCode.isDark(row, col) ) {
					darkCount += 1;
				}
			}
		}
		
		let ratio = Int(abs(100 * darkCount / moduleCount / moduleCount - 50)) / 5;
		lostPoint += ratio * 10;
		
		return lostPoint;
	}
	
	
	static func getPatternPosition(_ typeNumber:Int) ->[Int] {
		return PATTERN_POSITION_TABLE[typeNumber - 1];
	}
	
	static func getMaxLength(_ typeNumber:Int, _ mode:QRData.QRMode, _ errorCorrectionLevel:QRCode.ErrorCorrectionLevel) -> Int{
		
		let t = typeNumber - 1;
		var e = 0;
		var m = 0;
		
		switch(errorCorrectionLevel) {
		case QRCode.ErrorCorrectionLevel.L : e = 0; break;
		case QRCode.ErrorCorrectionLevel.M : e = 1; break;
		case QRCode.ErrorCorrectionLevel.Q : e = 2; break;
		case QRCode.ErrorCorrectionLevel.H : e = 3; break;
		}
		
		switch(mode) {
		case QRData.QRMode.MODE_NUMBER    : m = 0; break;
		case QRData.QRMode.MODE_ALPHA_NUM : m = 1; break;
		case QRData.QRMode.MODE_8BIT_BYTE : m = 2; break;
		case QRData.QRMode.MODE_KANJI     : m = 3; break;
		}
		
		return MAX_LENGTH[t][e][m];
	}
	
	static func getErrorCorrectPolynomial(_ errorCorrectLength:Int) -> QRPolynomial {
		var a =  QRPolynomial([1]);
		for i in 0..<errorCorrectLength {
			a = try! a * QRPolynomial([1, QRMath.gexp(i)])
		}
		return a;
	}
	
	static func getMask(_ maskPattern:QRMaskPattern, _ i:Int, _ j:Int) -> Bool {
		
		switch maskPattern {
		case .PATTERN000 : return (i + j) % 2 == 0;
		case .PATTERN001 : return i % 2 == 0;
		case .PATTERN010 : return j % 3 == 0;
		case .PATTERN011 : return (i + j) % 3 == 0;
		case .PATTERN100 : return (i / 2 + j / 3) % 2 == 0;
		case .PATTERN101 : return (i * j) % 2 + (i * j) % 3 == 0;
		case .PATTERN110 : return ( (i * j) % 2 + (i * j) % 3) % 2 == 0;
		case .PATTERN111 : return ( (i * j) % 3 + (i + j) % 2) % 2 == 0;
		}
	}
	
	public static func getMode(_ s:String) -> QRData.QRMode {
		if (isAlphaNum(s) ) {
			if (isNumber(s) ) {
				return QRData.QRMode.MODE_NUMBER;
			}
			return QRData.QRMode.MODE_ALPHA_NUM;
		} else if (isKanji(s) ) {
			return QRData.QRMode.MODE_KANJI;
		} else {
			return QRData.QRMode.MODE_8BIT_BYTE;
		}
	}
	
	private static func isNumber(_ str:String) ->Bool {
		
		for ch in str {
			if !("0" <= ch && ch <= "9") {
				return false;
			}
		}
		
		return true;
	}
	
	private static func isAlphaNum(_ str:String) ->Bool  {
		
		for ch in str {
			if !("0" <= ch && ch <= "9") && !("A" <= ch && ch <= "Z") && " $%*+-./:".index(of:ch) == nil  {
				return false;
			}
		}
		
		return true;
	}
	
	private static func isKanji(_ str:String) -> Bool{
		
		var i = 0;
		let data = str.data(using: .shiftJIS, allowLossyConversion: true)!
		
		while i + 1 < data.count {
			
			let c =  ( UInt16(data[i]) << 8) | UInt16(data[i + 1]);
			
			if (!(0x8140 <= c && c <= 0x9FFC) && !(0xE040 <= c && c <= 0xEBBF) ) {
				return false;
			}
			
			i += 2;
		}
		
		if (i < data.count) {
			return false;
		}
		
		return true;
	}
	
	
	public static func getBCHTypeInfo(_ data:Int) -> Int {
		var d = data << 10;
		while (getBCHDigit(d) - getBCHDigit(G15) >= 0) {
			d ^= (G15 << (getBCHDigit(d) - getBCHDigit(G15)));
		}
		
		return ( (data << 10) | d) ^ G15_MASK;
	}
	
	public static func getBCHTypeNumber(_ data:Int) -> Int {
		var d = data << 12;
		while (getBCHDigit(d) - getBCHDigit(G18) >= 0) {
			d ^= (G18 << (getBCHDigit(d) - getBCHDigit(G18) ) );
		}
		
		return (data << 12) | d;
	}
	
	private static func getBCHDigit(_ data:Int) -> Int {
		
		var digit = 0;
		var d = data;
		
		while (d != 0) {
			digit += 1;
			d = (d >> 1);
		}
		
		return digit;
	}
	
	private static let G15 =      0b000000010100110111
	private static let G18 =      0b000001111100100101
	private static let G15_MASK = 0b000101010000010010
	
	
	private static let PATTERN_POSITION_TABLE = [
		[],
		[6, 18],
		[6, 22],
		[6, 26],
		[6, 30],
		[6, 34],
		[6, 22, 38],
		[6, 24, 42],
		[6, 26, 46],
		[6, 28, 50],
		[6, 30, 54],
		[6, 32, 58],
		[6, 34, 62],
		[6, 26, 46, 66],
		[6, 26, 48, 70],
		[6, 26, 50, 74],
		[6, 30, 54, 78],
		[6, 30, 56, 82],
		[6, 30, 58, 86],
		[6, 34, 62, 90],
		[6, 28, 50, 72, 94],
		[6, 26, 50, 74, 98],
		[6, 30, 54, 78, 102],
		[6, 28, 54, 80, 106],
		[6, 32, 58, 84, 110],
		[6, 30, 58, 86, 114],
		[6, 34, 62, 90, 118],
		[6, 26, 50, 74, 98, 122],
		[6, 30, 54, 78, 102, 126],
		[6, 26, 52, 78, 104, 130],
		[6, 30, 56, 82, 108, 134],
		[6, 34, 60, 86, 112, 138],
		[6, 30, 58, 86, 114, 142],
		[6, 34, 62, 90, 118, 146],
		[6, 30, 54, 78, 102, 126, 150],
		[6, 24, 50, 76, 102, 128, 154],
		[6, 28, 54, 80, 106, 132, 158],
		[6, 32, 58, 84, 110, 136, 162],
		[6, 26, 54, 82, 110, 138, 166],
		[6, 30, 58, 86, 114, 142, 170]
	];
	
	private static let MAX_LENGTH = [
		[ [41,  25,  17,  10],  [34,  20,  14,  8],   [27,  16,  11,  7],  [17,  10,  7,   4] ],
		[ [77,  47,  32,  20],  [63,  38,  26,  16],  [48,  29,  20,  12], [34,  20,  14,  8] ],
		[ [127, 77,  53,  32],  [101, 61,  42,  26],  [77,  47,  32,  20], [58,  35,  24,  15] ],
		[ [187, 114, 78,  48],  [149, 90,  62,  38],  [111, 67,  46,  28], [82,  50,  34,  21] ],
		[ [255, 154, 106, 65],  [202, 122, 84,  52],  [144, 87,  60,  37], [106, 64,  44,  27] ],
		[ [322, 195, 134, 82],  [255, 154, 106, 65],  [178, 108, 74,  45], [139, 84,  58,  36] ],
		[ [370, 224, 154, 95],  [293, 178, 122, 75],  [207, 125, 86,  53], [154, 93,  64,  39] ],
		[ [461, 279, 192, 118], [365, 221, 152, 93],  [259, 157, 108, 66], [202, 122, 84,  52] ],
		[ [552, 335, 230, 141], [432, 262, 180, 111], [312, 189, 130, 80], [235, 143, 98,  60] ],
		[ [652, 395, 271, 167], [513, 311, 213, 131], [364, 221, 151, 93], [288, 174, 119, 74] ]
	]
	
}
