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
        case red, magenta, green, blue, orange, yellow
        
        public func color() -> UIColor {
            switch self {
            case .red:
                return UIColor(red:0.93, green:0.26, blue:0.26, alpha:1.0)
            case .magenta:
                return UIColor(red:0.73, green:0.20, blue:0.31, alpha:1.0)
            case .green:
                return UIColor(red:0.77, green:0.85, blue:0.43, alpha:1.0)
            case .blue:
                return UIColor(red:0.52, green:0.74, blue:0.85, alpha:1.0)
            case .orange:
                return UIColor(red:0.95, green:0.47, blue:0.28, alpha:1.0)
            case .yellow:
                return UIColor(red:0.96, green:0.68, blue:0.18, alpha:1.0)
            }
        }
    }
}
