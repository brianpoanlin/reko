//
//  QRCode.swift
//  QRCode Generator
//
//  Created by Vitali Kurlovich on 11/8/17.
//

import Foundation

enum QRCodeError: Error {
	case QRCodeErrorBufferOverflow(bufferLenght:Int, totalDataCount:Int)
}

final class QRCodeProcessor {
	
	var typeNumber = 1;
	var errorCorrectionLevel = QRCode.ErrorCorrectionLevel.H;
	
	private static let PAD0 = 0xEC;
	private static let PAD1 = 0x11;
	
	private var modules:[[Bool?]] = [];
	private var _moduleCount:Int = 0;
	private var qrDataList = [QRData]();
	
	var moduleCount : Int  {
		get {
			return _moduleCount;
		}
	}
	
	func addData(data:String) {
		addData(data, QRUtil.getMode(data) );
	}
	
	
	func addData(_ data:Data) {
		addData(QR8BitByte(data))
	}
	
	func addData(_ data:String, _ mode:QRData.QRMode) {
		
		switch mode {
			
		case QRData.QRMode.MODE_NUMBER :
			addData(QRNumber(data))
			break;
			
		case QRData.QRMode.MODE_ALPHA_NUM :
			addData(QRAlphaNum(data))
			break;
			
		case QRData.QRMode.MODE_8BIT_BYTE :
			addData(QR8BitByte(data))
			break;
			
		case QRData.QRMode.MODE_KANJI :
			addData(QRKanji(data))
			break;
		}
	}
	
	func clearData() {
		qrDataList.removeAll();
	}
	
	
	func addData(_ qrData:QRData) {
		qrDataList.append(qrData);
	}
	
	internal func getDataCount() -> Int {
		return qrDataList.count;
	}
	
	internal func getData(_ index:Int) -> QRData {
		return qrDataList[index];
	}
	
	func isDark(_ row:Int, _ col:Int) ->Bool {
		let dark = modules[row][col];
		if dark == nil {
			return false;
		}
		return  modules[row][col]!
	}
	
	private func getBestMaskPattern() throws -> QRUtil.QRMaskPattern {
		
		var minLostPoint = 0;
		var pattern = QRUtil.QRMaskPattern.PATTERN000;
		
		for  i in QRUtil.QRMaskPattern.allPatterns {
			
			try make(true, i);
			
			let lostPoint = QRUtil.getLostPoint(self);
			
			if i == QRUtil.QRMaskPattern.PATTERN000 || minLostPoint > lostPoint {
				minLostPoint = lostPoint;
				pattern = i;
			}
		}
		
		return pattern;
	}
	
	func make() throws {
		let pattern = try getBestMaskPattern()
		try make(false, pattern)
	}
	
	private func make(_ test:Bool, _ maskPattern:QRUtil.QRMaskPattern) throws {
		_moduleCount = typeNumber * 4 + 17;
		modules = [[Bool?]](repeatElement([Bool?](repeatElement(nil, count:moduleCount)), count:moduleCount))
		
		setupPositionProbePattern(0, 0);
		setupPositionProbePattern(moduleCount - 7, 0);
		setupPositionProbePattern(0, moduleCount - 7);
		
		setupPositionAdjustPattern();
		setupTimingPattern();
		
		setupTypeInfo(test, maskPattern);
		
		if typeNumber >= 7 {
			setupTypeNumber(test);
		}
		
		let data = try QRCodeProcessor.createData(typeNumber, errorCorrectionLevel, qrDataList);
		
		mapData(data, maskPattern);
	}
	
	private func mapData(_ data:[UInt8], _ maskPattern:QRUtil.QRMaskPattern) {
		
		var inc = -1;
		var row = moduleCount - 1;
		var bitIndex = 7;
		var byteIndex = 0;
		var col = moduleCount - 1
		
		while( col > 0)  {
			
			if col == 6 {
				col -= 1;
			}
			
			while (true) {
				
				for  c in 0..<2 {
					
					if (modules[row][col - c] == nil) {
						
						var dark = false;
						
						if (byteIndex < data.count) {
							dark = ( ( (data[byteIndex] >> bitIndex) & 1) == 1);
						}
						
						let mask = QRUtil.getMask(maskPattern, row, col - c);
						if (mask) {
							dark = !dark;
						}
						
						modules[row][col - c] = dark;
						bitIndex -= 1;
						
						if (bitIndex == -1) {
							byteIndex += 1;
							bitIndex = 7;
						}
					}
				}
				
				row += inc;
				
				if (row < 0 || moduleCount <= row) {
					row -= inc;
					inc = -inc;
					break;
				}
			}
			
			col -= 2
		}
	}
	
	private func setupPositionAdjustPattern() {
		
		let pos = QRUtil.getPatternPosition(typeNumber);
		
		for  i in 0..<pos.count {
			for  j in 0..<pos.count {
				
				let row = pos[i]
				let col = pos[j]
				
				if (modules[row][col] != nil) {
					continue;
				}
				
				for  r in -2...2 {
					for  c in -2...2 {
						modules[row + r][col + c] = (r == -2 || r == 2 || c == -2 || c == 2
							|| (r == 0 && c == 0))
					}
				}
			}
		}
	}
	
	
	private func setupPositionProbePattern(_ row:Int, _ col:Int) {
		
		for r in -1...7 {
			for c in -1...7 {
				
				if row + r <= -1 || moduleCount <= (row + r)
					|| col + c <= -1 || moduleCount <= (col + c) {
					continue;
				}
				
				modules[row + r][col + c] = ( (0 <= r && r <= 6 && (c == 0 || c == 6) )
					|| (0 <= c && c <= 6 && (r == 0 || r == 6) )
					|| (2 <= r && r <= 4 && 2 <= c && c <= 4) )
			}
		}
	}
	
	
	private func setupTimingPattern() {
		for  r in 8..<(moduleCount - 8) {
			if (modules[r][6] != nil) {
				continue;
			}
			modules[r][6] = (r % 2 == 0)
		}
		for  c in 8..<(moduleCount - 8) {
			if (modules[6][c] != nil) {
				continue;
			}
			modules[6][c] = (c % 2 == 0);
		}
	}
	
	
	private func setupTypeNumber(_ test:Bool) {
		
		let bits = QRUtil.getBCHTypeNumber(typeNumber);
		
		for  i in 0..<18 {
			let mod = (!test && ( (bits >> i) & 1) == 1);
			modules[i / 3][i % 3 + moduleCount - 8 - 3] = mod;
		}
		
		for  i in 0..<18 {
			let mod = (!test && ( (bits >> i) & 1) == 1);
			modules[i % 3 + moduleCount - 8 - 3][i / 3] = mod;
		}
	}
	
	
	private func setupTypeInfo(_ test:Bool, _ maskPattern:QRUtil.QRMaskPattern) {
		
		let data = (errorCorrectionLevel.rawValue << 3) | maskPattern.rawValue;
		let bits = QRUtil.getBCHTypeInfo(data);
		
		for i in 0..<15 {
			
			let mod = (!test && ( (bits >> i) & 1) == 1)
			
			if i < 6 {
				modules[i][8] = mod;
			} else if i < 8 {
				modules[i + 1][8] = mod;
			} else {
				modules[moduleCount - 15 + i][8] = mod;
			}
		}
		
		for  i in 0..<15 {
			
			let mod = (!test && ((bits >> i) & 1) == 1);
			
			if i < 8 {
				modules[8][moduleCount - i - 1] = mod;
			} else if i < 9 {
				modules[8][15 - i - 1 + 1] = mod;
			} else {
				modules[8][15 - i - 1] = mod;
			}
		}
		
		modules[moduleCount - 8][8] = !test;
	}
	
	
	static func  createData(_ typeNumber:Int, _ errorCorrectionLevel:QRCode.ErrorCorrectionLevel, _ dataArray:[QRData]) throws -> [UInt8] {
		
		var buffer = QRBitBuffer();
		for  data in dataArray {
			buffer.put(data.mode.rawValue, 4);
			buffer.put(data.lenght, data.getLengthInBits(typeNumber) );
			data.write(&buffer);
		}
		
		let rsBlocks = RSBlock.getRSBlocks(typeNumber, errorCorrectionLevel);
		let totalDataCount = rsBlocks.reduce(0){$0 + $1.dataCount};
		
		if (buffer.count > totalDataCount * 8) {
			throw QRCodeError.QRCodeErrorBufferOverflow(bufferLenght: buffer.count, totalDataCount: totalDataCount * 8)
		}
		
		if (buffer.count + 4 <= totalDataCount * 8) {
			buffer.put(0, 4);
		}
		
		// padding
		while (buffer.count % 8 != 0) {
			buffer.put(false);
		}
		
		// padding
		while (true) {
			
			if (buffer.count >= totalDataCount * 8) {
				break;
			}
			buffer.put(PAD0, 8);
			
			if (buffer.count >= totalDataCount * 8) {
				break;
			}
			buffer.put(PAD1, 8);
		}
		
		return try createBytes(buffer, rsBlocks);
	}
	
	private static func createBytes(_ buffer:QRBitBuffer, _ rsBlocks:[RSBlock]) throws -> [UInt8]{
		
		var offset = 0;
		
		var maxDcCount = 0;
		var maxEcCount = 0;
		
		var dcdata = [[Int]](repeatElement([Int](), count:rsBlocks.count));
		var ecdata = [[Int]](repeatElement([Int](), count:rsBlocks.count));
		
		for  r in 0..<rsBlocks.count {
			
			let dcCount = rsBlocks[r].dataCount
			let ecCount = rsBlocks[r].totalCount - dcCount;
			
			maxDcCount = max(maxDcCount, dcCount);
			maxEcCount = max(maxEcCount, ecCount);
			
			dcdata[r] = [Int](repeatElement(0, count:dcCount));
			
			for  i in 0..<dcdata[r].count {
				dcdata[r][i] = Int(0xff & buffer.buffer[i + offset]);
			}
			offset += dcCount;
			
			let rsPoly = QRUtil.getErrorCorrectPolynomial(ecCount);
			let rawPoly =  QRPolynomial(dcdata[r], rsPoly.lenght - 1)
			
			let modPoly =  try rawPoly % rsPoly
			
			ecdata[r] = [Int](repeatElement(0, count:rsPoly.lenght - 1))
			
			
			for  i in 0..<ecdata[r].count {
				let modIndex = i + modPoly.lenght - ecdata[r].count;
				ecdata[r][i] = (modIndex >= 0) ? modPoly[modIndex] : 0;
			}
		}
		
		let totalCodeCount = rsBlocks.reduce(0){$0 + $1.totalCount};
		
		var data = [UInt8](repeatElement(0, count:totalCodeCount))
		
		var index = 0;
		
		for  i in 0..<maxDcCount {
			for  r in 0..<rsBlocks.count {
				if i < dcdata[r].count {
					data[index] = UInt8(dcdata[r][i]);
					index += 1
				}
			}
		}
		
		for  i in 0..<maxEcCount {
			for  r in 0..<rsBlocks.count {
				if (i < ecdata[r].count) {
					data[index] = UInt8(ecdata[r][i]);
					index += 1
				}
			}
		}
		
		return data;
	}
	
	
	private static func getMinimumQRCode(_ qr:QRCodeProcessor, _ mode:QRData.QRMode) throws  -> [[Bool]] {
	
		let length = qr.getData(0).lenght;
		
		for typeNumber in 1...10 {
			if (length <= QRUtil.getMaxLength(typeNumber, mode, qr.errorCorrectionLevel) ) {
				qr.typeNumber = typeNumber;
				break;
			}
		}
		
		try qr.make();
		
		var modules = [[Bool]](repeatElement([Bool](repeatElement(false, count: qr.moduleCount)), count:qr.moduleCount))
		
		for row in 0..<qr.moduleCount {
			for col in 0..<qr.moduleCount {
				modules[row][col] = qr.isDark(row, col)
			}
		}
		
		return modules
	}
	
	static func getMinimumQRCode(_ data:String, _ errorCorrectionLevel:QRCode.ErrorCorrectionLevel) throws  -> [[Bool]] {
		
		let mode = QRUtil.getMode(data);
		
		let qr = QRCodeProcessor();
		qr.errorCorrectionLevel = errorCorrectionLevel;
		qr.addData(data, mode);
		
		return try getMinimumQRCode(qr, mode)
	}
	
	
	static func getMinimumQRCode(_ data:Data, _ errorCorrectionLevel:QRCode.ErrorCorrectionLevel) throws  -> [[Bool]] {
		
		let qr = QRCodeProcessor();
		qr.errorCorrectionLevel = errorCorrectionLevel;
		qr.addData(data);
	
		return try getMinimumQRCode(qr, QRData.QRMode.MODE_8BIT_BYTE)
	}
}
