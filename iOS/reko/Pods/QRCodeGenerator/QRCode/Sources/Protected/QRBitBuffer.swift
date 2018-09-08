//
//  QRBitBuffer.swift
//  QRCode Generator
//
//  Created by Vitali Kurlovich on 11/8/17.
//



struct QRBitBuffer {
	
	private var _buffer = [UInt8]()
	private var _count = 0
	
	var count: Int {
		get {
			return _count;
		}
	}
	
	var buffer : [UInt8] {
		get {
			return _buffer;
		}
	}
	
	subscript(_ index:Int) -> Bool {
		let byteIndex = index/8
		let byte = _buffer[byteIndex]
		return (byte >> (7 - index % 8)) & 1 == 1;
	}
	
	mutating func put(_ bit:Bool) {
		let byteIndex = _count/8
		if _buffer.count <= byteIndex {
			_buffer.append(0)
		}
		if bit {
			_buffer[byteIndex] |= (0x80 >> (_count % 8));
		}
		_count += 1
	}
	
	mutating func put(_ num:Int, _ len:Int) {
		for  i in 0..<len {
			put(( (num >> (len - i - 1) ) & 1) == 1);
		}
	}
}

