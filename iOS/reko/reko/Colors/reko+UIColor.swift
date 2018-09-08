//
//  reko+UIColor.swift
//  reko
//
//  Created by Brian Lin on 9/7/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit

extension UIColor {
    public enum reko {
        case red, blue, green
        
        public func color() -> UIColor {
            switch self {
            case .red:
                return UIColor(red:0.93, green:0.26, blue:0.26, alpha:1.0)
            case .blue:
                return UIColor(red:0.93, green:0.26, blue:0.26, alpha:1.0)
            case .green:
                return UIColor(red:0.93, green:0.26, blue:0.26, alpha:1.0)
            }
        }
    }
}
