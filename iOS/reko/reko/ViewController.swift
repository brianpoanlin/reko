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
    private var card = CardsView(viewModel: CardsViewModel(type: CardType.PersonalInfo, elements: ["hunter", "lol"], id: 0))
    private var panGesture = UIPanGestureRecognizer()
    private var swipeGesture = UISwipeGestureRecognizer()
    private let socket = Socket()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeGesture.direction = .up
        card.isUserInteractionEnabled = true
//        card.addGestureRecognizer(panGesture)
        card.addGestureRecognizer(swipeGesture)
//        socket.connect()
        
//        view.addSubview(card)
//        setupCardConstraints()
        
        socket.delegate = self
    }
    

    
    @objc func draggedView(_ sender: UIPanGestureRecognizer){
        self.view.bringSubview(toFront: card)
        let translation = sender.translation(in: self.view)
        card.center = CGPoint(x: card.center.x, y: card.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc func swiped(){
        print("swipedup")
        UIView.animate(withDuration: 0.5, animations: {
            self.card.center = CGPoint(x: self.card.center.x, y: self.card.center.y + 900)
            })
    }

    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tappedStudent(_ sender: Any) {
        
        let stack: [CardsView] = [CardsView(viewModel: CardsViewModel(type: CardType.PersonalInfo, elements: ["hunter", "lol"], id: 0))]
//        present(QRCodeViewController(withContent: "brianpoanlin.com"), animated: true, completion: nil)
//        present(CardStackViewController(withStack: stack), animated: true, completion: nil)
        let navigationController = UINavigationController(rootViewController: CardStackViewController(withStack: stack))
        present(navigationController, animated: true, completion: nil)
        

//        socket.sendUpdate()

        
//        view.addSubview(card)
//        setupCardConstraints()
    }
    
    @IBAction func tappedRecruiter(_ sender: Any) {
        let navigationController = UINavigationController(rootViewController: RecruiterViewController())
        present(navigationController, animated: true, completion: nil)
    }
    
    private func setupCardConstraints() {
        card.translatesAutoresizingMaskIntoConstraints = false
        card.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -20).isActive = true
        card.heightAnchor.constraint(equalToConstant: 200).isActive = true
        card.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        card.topAnchor.constraint(equalTo: view.topAnchor, constant: -300).isActive = true
        
        card.categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        card.categoryLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20).isActive = true
        card.categoryLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20).isActive = true
        
        card.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.titleLabel.topAnchor.constraint(equalTo: card.categoryLabel.bottomAnchor, constant: 10).isActive = true
        card.titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20).isActive = true
    }
    
}

extension ViewController: SocketDelegate {
    func receivedCardStack(data: [Any]) {
        
    }
    
    func receivedNewCard(data: [Any]) {
        print("view controller received card")
        swiped()
    }
    
    
}

