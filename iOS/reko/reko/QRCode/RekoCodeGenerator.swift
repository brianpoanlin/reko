//
//  RekoCodeGenerator.swift
//  reko
//
//  Created by Brian Lin on 9/7/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit
import QRCodeGenerator

public class RekoCodeGenerator {
    
    public class func generatedQRCode(withCode content: String) -> UIImage? {
        let code = try! QRCode(content, .M)
        return UIImage.qrCodeImage(code, CGSize(width: 200, height: 200))
    }
    
}
