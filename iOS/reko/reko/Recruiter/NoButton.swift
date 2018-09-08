//
//  NoButton.swift
//  reko
//
//  Created by Brian Lin on 9/8/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit

class NoButton: UIButton {
    
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        setImage(UIImage(named: "x.png"), for: .normal)
        imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        backgroundColor = UIColor.reko.red.color()
        layer.cornerRadius = 10
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
