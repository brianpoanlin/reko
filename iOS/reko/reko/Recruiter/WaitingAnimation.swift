//
//  WaitingAnimation.swift
//  reko
//
//  Created by Brian Lin on 9/8/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit

public class WaitingAnimation: UIView {
    
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
        backgroundColor = .white
        layer.borderWidth = 2
        layer.borderColor = UIColor.reko.red.color().cgColor
        layer.cornerRadius = 25
    }
    
    public func startAnimating() {
        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)
    }
}
