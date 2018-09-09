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
//    private var stack = [CardsView(viewModel: CardsViewModel(type: CardType.PersonalInfo, elements: ["Hunter Harloff", "hunter@umich.edu", "111-111-1111"], id: 0)), CardsView(viewModel: CardsViewModel(type: CardType.Education, elements: ["University of Michigan", "Class of 2021"], id: 1)), CardsView(viewModel: CardsViewModel(type: CardType.WorkExperience, elements: ["Software Engineer, Facebook", "June 2018 - Aug 2018"], id: 2))]
    private var stackOfCards = [CardsView]()
    
    private var focused: Bool = false
    private var originalPosition: CGPoint!
    private var focusedTag: Int!
    private let socket = Socket()
    
    private let endSessionButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    
    private var progressIndicator: UIActivityIndicatorView!
    
    var maskView = UIView()

    public init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        socket.delegate = self
        socket.connect()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.red]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.topItem?.title = "Student"

        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "connect_icon.png"), for: .normal)
        button.addTarget(self, action:#selector(connectTapped), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        
        self.navigationItem.title = "Student"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        progressIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2-50, y: self.view.frame.height/2-50, width: 100, height: 100))
        progressIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(progressIndicator)
        progressIndicator.startAnimating()
    }
    
    @objc
    private func connectTapped() {
        present(QRCodeViewController(withContent: "brianlin.com"), animated: true, completion: nil )
    }
    
    private func setupView() {
        
        endSessionButton.setTitle("End Interview", for: .normal)
        endSessionButton.setTitleColor(UIColor.reko.red.color(), for: .normal)
        endSessionButton.setTitleColor(UIColor.reko.gray.color(), for: .highlighted)
        endSessionButton.backgroundColor = UIColor.clear
        endSessionButton.layer.cornerRadius = 5
        endSessionButton.layer.borderColor = UIColor.reko.red.color().cgColor
        endSessionButton.layer.borderWidth = 2
        endSessionButton.addTarget(self, action: #selector(endInterviewTapped), for: .touchUpInside)
        view.addSubview(endSessionButton)
        
        stackOfCards.forEach({
            view.addSubview($0)
            $0.delegate = self
        })
    }
    
    private func setupConstraint() {
        stackOfCards[0].translatesAutoresizingMaskIntoConstraints = false
        stackOfCards[0].widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -20).isActive = true
        stackOfCards[0].heightAnchor.constraint(equalToConstant: 200).isActive = true
        stackOfCards[0].topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
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
        
        endSessionButton.translatesAutoresizingMaskIntoConstraints = false
        endSessionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        endSessionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        endSessionButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        endSessionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }
    
    @objc
    private func endInterviewTapped() {
        socket.endSession()
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
    func startedSession() {
        
    }
    
    func endedSession(data: [Any]) {
        
    }
    
    func receivedNewCard(data: [Any]) {
        
    }
    
    func receivedCardStack(data: [Any]) {
        progressIndicator.hidesWhenStopped = true
        progressIndicator.stopAnimating()
        
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
