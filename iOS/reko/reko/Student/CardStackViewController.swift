//
//  CardStackViewController.swift
//  reko
//
//  Created by Brian Lin on 9/8/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit
import SwiftyJSON

class CardStackViewController: UIViewController {
    
//    private var stack = [CardsView(viewModel: CardsViewModelGreen()), CardsView(viewModel: CardsViewModelYellow()), CardsView(viewModel: CardsViewModelGreen()), CardsView(viewModel: CardsViewModelBlue()), PersonalInformationCard(name: "Hunger", email: "email", phone: "phone", link: "link")]
    private var stack = [CardsView(viewModel: CardsViewModel(type: CardType.PersonalInfo, elements: ["Hunter Harloff", "hunter@umich.edu", "111-111-1111"], id: 0)), CardsView(viewModel: CardsViewModel(type: CardType.Education, elements: ["University of Michigan", "Class of 2021"], id: 1)), CardsView(viewModel: CardsViewModel(type: CardType.WorkExperience, elements: ["Software Engineer, Facebook", "June 2018 - Aug 2018"], id: 2))]
    private var stackOfCards = [CardsView]()
    
    private var focused: Bool = false
    private var originalPosition: CGPoint!
    private var focusedTag: Int!
    private let socket = Socket()
    
    var maskView = UIView()

    private init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        socket.delegate = self
        socket.connect()
    }
    
    public convenience init(withStack stackToUse: [CardsView]) {
        self.init()
        self.stack = stackToUse
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().barTintColor = UIColor.reko.red.color()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]

        self.navigationController?.setNavigationBarHidden(false, animated: false)

    }
    
    private func setupView() {
        stackOfCards.forEach({
            view.addSubview($0)
            $0.delegate = self
        })
    }
    
    private func setupConstraint() {
        stackOfCards[0].translatesAutoresizingMaskIntoConstraints = false
        stackOfCards[0].widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -20).isActive = true
        stackOfCards[0].heightAnchor.constraint(equalToConstant: 200).isActive = true
        stackOfCards[0].topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        stackOfCards[0].centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackOfCards[0].setupSubviewConstraints()
        
        for i in 1..<stackOfCards.count {
            stackOfCards[i].translatesAutoresizingMaskIntoConstraints = false
            stackOfCards[i].widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -20).isActive = true
            stackOfCards[i].heightAnchor.constraint(equalToConstant: 200).isActive = true
            stackOfCards[i].topAnchor.constraint(equalTo: stackOfCards[i-1].topAnchor, constant: 40).isActive = true
            stackOfCards[i].centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            stackOfCards[i].setupSubviewConstraints()

        }
    }
    
    private func resetCards() {
       
    }

}

extension CardStackViewController: CardsViewDelegate {
    func swipedDown(sender: CardsView) {
        print("Dismiss")
        if focused && focusedTag == sender.id {
            maskView.removeFromSuperview()
            focused = false
            
            UIView.animate(withDuration: 0.2, animations: {
                sender.transform = CGAffineTransform(translationX: 0.0, y: 500.0)
            }, completion: { bool in
            
                UIView.animate(withDuration: 0.5, animations: {
                    let translation = sender.center.y - self.originalPosition.y
                    sender.transform = CGAffineTransform(translationX: 0.0, y: -translation)
                }, completion: { bool in
                    print("Resetted")
                    self.resetCards()
                })
            })
        } else if !focused {
            focused = true
            focusedTag = sender.id
            print(sender.id)
            maskView = UIView(frame: self.view.frame)
            maskView.backgroundColor = .black
            
            self.maskView.alpha = 0.5
            
            originalPosition = sender.center
            
            
            UIView.animate(withDuration: 0.3, animations: {
                let translation = self.view.frame.height - sender.frame.height / 2 - 20 - sender.center.y
                sender.transform = CGAffineTransform(translationX: 0.0, y: translation)
            })
        }
    }
    
    func swipedUp(sender: CardsView) {
        print("Swiped up!!!!!")
        if focused && focusedTag == sender.id {
            view.bringSubview(toFront: sender)
            socket.sendUpdate(sender: sender)
            UIView.animate(withDuration: 0.4, animations: {
                sender.center = CGPoint(x: sender.center.x, y: sender.center.y - 1000)
                self.maskView.alpha = 0
            }, completion: { bool in
                sender.removeFromSuperview()
            })
            
            focused = false
        }
    }
    
    func tapped(sender: CardsView) {
        if !focused {
            focused = true
            focusedTag = sender.id
            print(sender.id)
            maskView = UIView(frame: self.view.frame)
            maskView.backgroundColor = .black

            self.maskView.alpha = 0.5

            originalPosition = sender.center
            

            UIView.animate(withDuration: 0.3, animations: {
                let translation = self.view.frame.height - sender.frame.height / 2 - 20 - sender.center.y
                sender.transform = CGAffineTransform(translationX: 0.0, y: translation)
            })
            
        } else if focused && focusedTag == sender.id {
            maskView.removeFromSuperview()
            focused = false
            
            UIView.animate(withDuration: 0.2, animations: {
                sender.transform = CGAffineTransform(translationX: 0.0, y: 500.0)
            }, completion: { bool in
                
                UIView.animate(withDuration: 0.5, animations: {
                    let translation = sender.center.y - self.originalPosition.y
                    sender.transform = CGAffineTransform(translationX: 0.0, y: -translation)
                }, completion: { bool in
                    print("Resetted")
                    self.resetCards()
                })
            })
        }
    }
    
    fileprivate func showCards() {
        print("\n\n\n\n\n\n\n\n\n\n\n\n\nFINAL CARDS\n\n")
        print(stackOfCards)
        setupView()
        setupConstraint()
    }
    
}

extension CardStackViewController: SocketDelegate {
    func receivedNewCard(data: [Any]) {
        
    }
    
    func receivedCardStack(data: [Any]) {
        let json: JSON = JSON(arrayLiteral: data.first)
        print("\n\n\n\n\n\n\n\n\n\n\n THIS IS JSON")
//        print(json)
        if let array: [JSON] = json.array {
            if let cardArray: JSON = array.first {
                
                if let cards = cardArray["card"].array {
                    for card in cards {
                        print(card)
                        print("\n\n\n\n")
                        let rawType = card["type"].stringValue
                        let id = card["id"].intValue
                        
                        let category = rawType.type()
                        var strings = [String]()
                        
                        if let elements = card["elements"].arrayObject {
                            for element in elements {
                                strings.append(element as! String)
                            }
                        }
                        
                        let newCardViewModel = CardsViewModel(type: category, elements: strings, id: id)
                        let newCard = CardsView(viewModel: newCardViewModel)
                        
                        stackOfCards.append(newCard)
                    }
                }
                
            }
        }
        
        showCards()
    }
    
    
}
