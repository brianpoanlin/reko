//
//  QRCodeView.swift
//  QRCode
//
//  Created by Vitali Kurlovich on 11/14/17.
//  Copyright © 2017 Vitali Kurlovich. All rights reserved.
//

import UIKit

@IBDesignable
public class QRCodeView: UIView {
	
	private lazy var  shapeLayer:CAShapeLayer =  {
		let layer = CAShapeLayer()
		self.layer.addSublayer(layer)
		return layer
	}()
	
	private var qrCode:QRCode? = nil;
	
	@IBInspectable
	public var text:String?  {
		didSet {
			self.data = text?.data(using: .shiftJIS, allowLossyConversion: true)!
		}
	};
	
	public var data:Data?  {
		didSet {
			updateQRCode()
			updatePathLayer()
		}
	};
	
	public var errorCorrectionLevel = QRCode.ErrorCorrectionLevel.H {
		didSet {
			updateQRCode()
			updatePathLayer()
		}
	}
	
	// MARK: - UIView
	
	override public func didMoveToSuperview() {
		super.didMoveToSuperview()
		
		updateQRCode()
		updatePathLayer()
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews();
		if self.shapeLayer.path == nil {
			return
		}
		
		guard (self.shapeLayer.path == nil) else {
			
			let transform = CGAffineTransform.transformForMode(contentMode:self.contentMode, bounds:self.bounds, contentBounds:(self.shapeLayer.path?.boundingBox)!)
			self.shapeLayer.setAffineTransform(transform);
			return
		}
	}
	
	public override func tintColorDidChange() {
		super.tintColorDidChange()
		self.shapeLayer.fillColor = self.tintColor.cgColor
	}
	

	// MARK: - Private
	
	private func updateQRCode() {
		do {
			if ((data) != nil) {
				qrCode = try QRCode(data!, errorCorrectionLevel)
			} else {
				qrCode = try QRCode("", errorCorrectionLevel)
			}
		} catch {
			qrCode = nil
		}
	}
	
	private func updatePathLayer() {
		
		if qrCode == nil {
			self.shapeLayer.path = nil
		} else {
			let bezier = UIBezierPath(qrCode!)
			let bounds = bezier.bounds
			bezier.apply(CGAffineTransform.identity.translatedBy(x: -bounds.midX, y: -bounds.midY))
			
			self.shapeLayer.path = bezier.cgPath;
		}
		self.shapeLayer.fillColor = self.tintColor.cgColor
		self.setNeedsLayout()
	}
}
