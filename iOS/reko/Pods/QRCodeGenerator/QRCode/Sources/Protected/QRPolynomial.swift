//
//  QRPolynomial.swift
//  QRCode Generator
//
//  Created by Vitali Kurlovich on 11/9/17.
//


struct QRPolynomial : Equatable {
	
	internal let num : [Int]
	var lenght : Int {
		get {
			return num.count;
		}
	}
	
	init(_ num:[Int]) {
		var offset = 0
		while (offset < num.count && num[offset] == 0) {
			offset += 1;
		}
		
		self.num = [Int](num[offset..<num.count]);
	}
	
	init(_ num:[Int], _ shift:Int) {
		var offset = 0
		while (offset < num.count && num[offset] == 0) {
			offset += 1;
		}
		
		var c  = [Int](num[offset..<num.count]);
		c.append(contentsOf:repeatElement(0, count: shift))
		self.num = c;
	}
	

	subscript(_ index:Int) ->Int {
		return num[index];
	}
	
	
	static func * (lhs: QRPolynomial, rhs: QRPolynomial) throws -> QRPolynomial {
		var nums = [Int](repeatElement(0, count: lhs.lenght + rhs.lenght - 1))
		for i in 0..<lhs.lenght {
			for j in 0..<rhs.lenght {
				nums[i + j] ^= QRMath.gexp(try QRMath.glog(lhs[i] ) + QRMath.glog(rhs[j]));
			}
		}
		return QRPolynomial(nums)
	}
		
	static func % (lhs: QRPolynomial, rhs: QRPolynomial) throws -> QRPolynomial {
		if lhs.lenght - rhs.lenght < 0 {
			return lhs;
		}
		
		let ratio = try QRMath.glog(lhs[0]) - QRMath.glog(rhs[0])
		var nums = lhs.num
		
		for i in 0..<rhs.lenght {
			nums[i] ^= QRMath.gexp(try QRMath.glog(rhs[i] ) + ratio);
		}
		return try QRPolynomial(nums) % rhs
	}
	
	// MARK: Equatable
	static func ==(lhs: QRPolynomial, rhs: QRPolynomial) -> Bool {
		return lhs.num == rhs.num
	}
}
