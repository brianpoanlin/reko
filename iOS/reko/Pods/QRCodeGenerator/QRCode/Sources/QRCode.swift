//
//  QRCodeResult.swift
//  QRCode Generator
//
//  Created by Vitali Kurlovich on 11/11/17.
//  Copyright © 2017 Vitali Kurlovich. All rights reserved.
//

import Foundation

 public struct QRCode {
	
	public enum ErrorCorrectionLevel : Int {
		/*!
		* 7%
		*/
		case L = 1
		
		/*!
		* 15%
		*/
		case M = 0;
		
		/*!
		* 25%
		*/
		case Q = 3;
		
		/*!
		* 30%
		*/
		case H = 2;
	}
	
	public let data : Data
	public let errorCorrection : ErrorCorrectionLevel
	public let modules:[[Bool]]
	
	public var size : Int {
		get {
			return modules.count;
		}
	}
	
	public subscript(_ row:Int, _ column:Int) -> Bool {
		return modules[row][column]
	}
	
	
	public init(_ data:String, _ errorCorrection : ErrorCorrectionLevel = .H) throws {
		self.data = data.data(using: .shiftJIS, allowLossyConversion: true)!
		self.errorCorrection = errorCorrection
		
		modules = try QRCodeProcessor.getMinimumQRCode(data, self.errorCorrection)
	}
	
	public init(_ data:Data, _ errorCorrection : ErrorCorrectionLevel = .H) throws {
		self.data = data
		self.errorCorrection = errorCorrection
		
		modules = try QRCodeProcessor.getMinimumQRCode(data, self.errorCorrection)
	}
}

extension QRCode : Equatable {
	
	public static func == (lhs: QRCode, rhs: QRCode) -> Bool {
		
		if (lhs.errorCorrection != rhs.errorCorrection || lhs.data != rhs.data) {
			return false;
		}
		
		if lhs.size != rhs.size {
			return false
		}
		
		for (index, row ) in lhs.modules.enumerated() {
			if row != rhs.modules[index] {
				return false
			}
		}
		
		return true
	}
}


