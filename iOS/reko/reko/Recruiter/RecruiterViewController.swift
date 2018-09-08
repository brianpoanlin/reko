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
    private var cardView: CardsView = CardsView(viewModel: CardsViewModelGreen())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket.connect()
        socket.delegate = self
        
        view.backgroundColor = .white

        self.view.addSubview(self.cardView)
        self.setupCardConstraints()
        // Do any additional setup after loading the view.
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
    func receivedNewCard(data: [Any]) {
//        print(data)
        
        view.subviews.forEach({
            $0.removeFromSuperview()
        })
        
        let json: JSON = JSON(arrayLiteral: data.first)
        print("THIS IS JSON")
        print(json)
        if let array: [JSON] = json.array {
            if let cardArray: JSON = array.first {
                let card = cardArray["card"]
                print(card["type"].stringValue)
                let viewModel = CardsViewModel(type: card["type"].stringValue, title: card["title"].stringValue, description: card["description"].stringValue, id: card["id"].intValue)
//                let viewModel = CardsViewModelBlue()
                let newCard = CardsView(viewModel: viewModel)
                view.addSubview(newCard)
                newCard.translatesAutoresizingMaskIntoConstraints = false
                newCard.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -20).isActive = true
                newCard.heightAnchor.constraint(equalToConstant: 500).isActive = true
                newCard.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                newCard.topAnchor.constraint(equalTo: view.topAnchor, constant: -500).isActive = true
                
                newCard.categoryLabel.translatesAutoresizingMaskIntoConstraints = false
                newCard.categoryLabel.topAnchor.constraint(equalTo: newCard.topAnchor, constant: 20).isActive = true
                newCard.categoryLabel.leadingAnchor.constraint(equalTo: newCard.leadingAnchor, constant: 20).isActive = true
                
                newCard.titleLabel.translatesAutoresizingMaskIntoConstraints = false
                newCard.titleLabel.topAnchor.constraint(equalTo: newCard.categoryLabel.bottomAnchor, constant: 10).isActive = true
                newCard.titleLabel.leadingAnchor.constraint(equalTo: newCard.leadingAnchor, constant: 20).isActive = true
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5, animations: {
                        let translation = self.view.frame.height / 2
                        newCard.center = CGPoint(x: newCard.center.x, y: translation)
                    })
                }
                
            }
        }
        

        
//        moveCardDown()

        
        
//            let card: JSON = array[0] as! JSON
//            print(card["type"].stringValue)
//            print(card)

    }
    
    
}
