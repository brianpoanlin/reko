//
//  QRAlphaNum.swift
//  QRCode Generator
//
//  Created by Vitali Kurlovich on 11/9/17.
//


final class QRAlphaNum: QRData {
	
	init(_ data:String) {
		super .init(QRMode.MODE_ALPHA_NUM, data)
	}
	
	override func write(_ buffer: inout QRBitBuffer) {
		
		
		
		var i = 0;
		while (i + 1 < data.count) {
			let first = data[String.Index(encodedOffset:i)]
			let second = data[String.Index(encodedOffset:(i+1))]
			let val = getCode(first) * 45 + getCode(second)
			buffer.put(val, 11);
			i += 2;
		}
		
		if i < data.count {
			let last = data[String.Index(encodedOffset:i)]
			let val = getCode(last)
			buffer.put(val, 6);
		}
	}
	
	
	private static let CHAR_MAP:Dictionary<Character, Int> = ["0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"A":10,"B":11,"C":12,"D":13,"E":14,"F":15,"G":16,"H":17,"I":18,"J":19,"K":20,"L":21,"M":22,"N":23,"O":24,"P":25,"Q":26,"R":27,"S":28,"T":29,"U":30,"V":31,"W":32,"X":33,"Y":34,"Z":35, " ":36, "$":37, "%":38, "*":39, "+":40, "-":41, ".":42, "/":43, ":":44];
	
	/*

	case ' ' : return 36;
	case '$' : return 37;
	case '%' : return 38;
	case '*' : return 39;
	case '+' : return 40;
	case '-' : return 41;
	case '.' : return 42;
	case '/' : return 43;
	case ':' : return 44;

*/
	
	private func getCode(_ c:Character) -> Int {
		return QRAlphaNum.CHAR_MAP[c]!;
		
		
		/*
		if ("0" <= c && c <= "9") {
		return c - '0';
		} else if ("A" <= c && c <= "Z") {
		return c - 'A' + 10;
		} else {
		switch (c) {
		case ' ' : return 36;
		case '$' : return 37;
		case '%' : return 38;
		case '*' : return 39;
		case '+' : return 40;
		case '-' : return 41;
		case '.' : return 42;
		case '/' : return 43;
		case ':' : return 44;
		default :
		throw new IllegalArgumentException("illegal char :" + c);
		}
		}
		*/
		//return 0;
		
	}
}
