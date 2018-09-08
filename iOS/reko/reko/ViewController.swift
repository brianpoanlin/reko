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
    private var card = CardsView(viewModel: CardsViewModel())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapped(_ sender: Any) {
//        present(QRCodeViewController(withContent: "brianpoanlin.com"), animated: true, completion: nil)
        view.addSubview(card)
        
//        card.translatesAutoresizingMaskIntoConstraints = false
//        card.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 20).isActive = true
        
        card.translatesAutoresizingMaskIntoConstraints = false
        card.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -20).isActive = true
        card.heightAnchor.constraint(equalToConstant: 200).isActive = true
        card.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        card.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        card.categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        card.categoryLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20).isActive = true
        card.categoryLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20).isActive = true
        
        card.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.titleLabel.topAnchor.constraint(equalTo: card.categoryLabel.bottomAnchor, constant: 10).isActive = true
        card.titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20).isActive = true
    }
    
}

