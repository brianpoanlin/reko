//
//  RecruiterViewController.swift
//  reko
//
//  Created by Brian Lin on 9/8/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit
import SwiftyJSON

class RecruiterViewController: UIViewController {

    private let socket = Socket()
    private var cardView: CardsView = CardsView(viewModel: CardsViewModel(type: CardType.PersonalInfo, elements: ["hunter", "lol"], id: 0))
    private let animation = WaitingAnimation()
    
    private let waitingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket.connect()
        socket.delegate = self
        
        view.backgroundColor = .white
        addAnimation()
        setupLabel()
        navigationController?.navigationBar.topItem?.title = "Recruiter"
        navigationController?.navigationBar.tintColor = UIColor.reko.red.color()



//        UINavigationBar.appearance().barTintColor = UIColor.reko.red.color()
//        UINavigationBar.appearance().tintColor = UIColor.red
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.reko.red.color()]
//        self.view.addSubview(self.cardView)
//        self.setupCardConstraints()
        // Do any additional setup after loading the view.
    }
    
    private func setupLabel() {
        waitingLabel.text = "Waiting..."
        waitingLabel.textAlignment = .center
        waitingLabel.textColor = UIColor.reko.red.color()
        view.addSubview(waitingLabel)
        
        waitingLabel.translatesAutoresizingMaskIntoConstraints = false
        waitingLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -20).isActive = true
        waitingLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        waitingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        waitingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true


    }
    
    private func addAnimation() {
        view.addSubview(animation)
        
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -200).isActive = true
        animation.heightAnchor.constraint(equalToConstant: 200).isActive = true
        animation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        animation.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        animation.startAnimating()
        
    }
    
    private func setupCardConstraints() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -20).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cardView.topAnchor.constraint(equalTo: view.topAnchor, constant: -500).isActive = true
        
        cardView.categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.categoryLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20).isActive = true
        cardView.categoryLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20).isActive = true
        
        cardView.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.titleLabel.topAnchor.constraint(equalTo: cardView.categoryLabel.bottomAnchor, constant: 10).isActive = true
        cardView.titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func moveCardDown() {
        print("RECEIVED CARD")
        UIView.animate(withDuration: 0.5, animations: {
            let translation = self.view.frame.height / 2
            self.cardView.center = CGPoint(x: self.cardView.center.x, y: translation)
        })
    }

}

extension RecruiterViewController: SocketDelegate {
    func receivedCardStack(data: [Any]) {
        
    }
    
    func receivedNewCard(data: [Any]) {
//        print(data)
        view.viewWithTag(1000)
        
//        view.subviews.forEach({
//            $0.removeFromSuperview()
//        })
        
        let json: JSON = JSON(arrayLiteral: data.first)
        print("THIS IS JSON")
        print(json)
        if let array: [JSON] = json.array {
            if let cardArray: JSON = array.first {
                let card = cardArray["card"]
                print(card["type"].stringValue)
                let type = card["type"].stringValue.type()
                let id = card["id"].intValue
                
                var strings = [String]()
                
                if let elements = card["elements"].arrayObject {
                    for element in elements {
                        strings.append(element as! String)
                    }
                }

                let viewModel = CardsViewModel(type: type, elements: strings, id: id)
                let newCard = CardsView(viewModel: viewModel)
                newCard.tag = 1000
                
                view.addSubview(newCard)
                newCard.translatesAutoresizingMaskIntoConstraints = false
                newCard.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -20).isActive = true
                newCard.heightAnchor.constraint(equalToConstant: 500).isActive = true
                newCard.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                newCard.topAnchor.constraint(equalTo: view.topAnchor, constant: -500).isActive = true
                newCard.setupSubviewConstraints()
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5, animations: {
                        let translation = self.view.frame.height / 2
                        newCard.center = CGPoint(x: newCard.center.x, y: translation)
                    })
                }
                
            }
        }

    }
    
    
}
