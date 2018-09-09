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
    private let slider = UISlider(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    private let valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    private let waitingLabel = UILabel()
    private let yesButton = YesButton()
    private let noButton = NoButton()
    private var focused = false {
        didSet {
            if focused {
                yesButton.alpha = 1
                yesButton.isEnabled = true
                noButton.alpha = 1
                noButton.isEnabled = true
            } else {
                yesButton.alpha = 0
                yesButton.isEnabled = false
                noButton.alpha = 0
                noButton.isEnabled = false

            }
        }
    }

    private var currentCard: CardsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket.connect()
        socket.delegate = self
        
        view.backgroundColor = .white
        addAnimation()
        setupLabel()
        setupSlider()
        self.navigationItem.title = "Recruiter"
        navigationController?.navigationBar.tintColor = UIColor.white

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.reko.red.color()]
    }
    
    private func setupSlider() {
        slider.maximumValue = 100
        slider.minimumValue = 0
        slider.tintColor = UIColor.reko.red.color()

        slider.maximumTrackTintColor = UIColor.reko.red.color()
        slider.maximumTrackTintColor = UIColor.white

        slider.value = 50
        view.addSubview(slider)
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        slider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        slider.heightAnchor.constraint(equalToConstant: 50).isActive = true
        slider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: [.touchUpInside, .touchUpOutside])
        
        valueLabel.textAlignment = .center
        valueLabel.font = UIFont(name: "Helvetica Neue", size: 24)
        valueLabel.text = "50%"
        valueLabel.textColor = UIColor.reko.red.color()
        
        view.addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        valueLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: 5).isActive = true
        
    }
    
    @objc
    private func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        DispatchQueue.main.async {
            self.valueLabel.text = "\(currentValue)%"
        }
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            if touchEvent.phase == .ended {
                if focused {
                    socket.sendImpression(type: currentCard.viewModel.category, impression: Int(slider.value))
                    DispatchQueue.main.async {
                        self.dismissView(self.view.viewWithTag(1000))
                    }
                }
                
                DispatchQueue.main.async {
                    self.slider.value = 50
                    self.valueLabel.text = "50%"
                }
                
            }
        }
    }
    
    private func setupLabel() {
        waitingLabel.text = "Waiting..."
        waitingLabel.textAlignment = .center
        waitingLabel.textColor = UIColor.white
        view.addSubview(waitingLabel)
        
        waitingLabel.translatesAutoresizingMaskIntoConstraints = false
        waitingLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -20).isActive = true
        waitingLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        waitingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        waitingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
//    @objc
//    private func handleYes() {
//        if focused {
//            dismissView(view.viewWithTag(1000))
//            socket.sendImpression(type: currentCard.viewModel.category, impression: true)
//        }
//    }
//
//    @objc
//    private func handleNo() {
//        if focused {
//            dismissView(view.viewWithTag(1000))
//            socket.sendImpression(type: currentCard.viewModel.category, impression: false)
//        }
//    }
    
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
    
//    private func moveCardDown() {
//        print("RECEIVED CARD")
//        UIView.animate(withDuration: 0.5, animations: {
//            let translation = self.view.frame.height / 2
//            self.cardView.center = CGPoint(x: self.cardView.center.x, y: translation)
//        })
//    }
    
    fileprivate func dismissView(_ view: UIView?) {
        if let view = view {
            UIView.animate(withDuration: 0.3, animations: {
                view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                view.alpha = 0
                self.focused = false

            }, completion: { bool in
                view.removeFromSuperview()
            })
        }
    }

}

extension RecruiterViewController: SocketDelegate {
    func startedSession() {
        
    }
    
    func endedSession() {
        
    }
    
    func receivedCardStack(data: [Any]) {
        
    }
    
    func receivedNewCard(data: [Any]) {
//        print(data)
//        view.subviews.forEach({
//            $0.removeFromSuperview()
//        })
        
        let json: JSON = JSON(arrayLiteral: data.first)

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
                
                DispatchQueue.main.async {
                    self.view.addSubview(newCard)
                    self.focused = true
                    newCard.translatesAutoresizingMaskIntoConstraints = false
                    newCard.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1, constant: -20).isActive = true
                    newCard.heightAnchor.constraint(equalToConstant: 500).isActive = true
                    newCard.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
                    newCard.centerXAnchor.constraint(equalTo:self.view.centerXAnchor).isActive = true
//                    newCard.centerYAnchor.constraint(equalTo:self.view.centerYAnchor).isActive = true

                    newCard.setupSubviewConstraints()
                }
                
                
                yesButton.backgroundColor = type.color
                noButton.backgroundColor = type.color
                animation.layer.borderColor = type.color.cgColor
                valueLabel.textColor = type.color
                slider.tintColor = type.color
                
                currentCard = newCard
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5, animations: {
                        let translation = self.view.frame.height + 500
                        newCard.center = CGPoint(x: newCard.center.x, y: translation)
                    })
                }
                
            }
        }

    }
    
    
}
