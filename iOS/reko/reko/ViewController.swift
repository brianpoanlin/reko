//
//  ViewController.swift
//  reko
//
//  Created by Brian Lin on 9/7/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit
import QRCodeGenerator

class ViewController: UIViewController {
    
    private let qrcode = UIImageView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapped(_ sender: Any) {
        present(QRCodeViewController(withContent: "lol"), animated: true, completion: nil)

    }
    
}

