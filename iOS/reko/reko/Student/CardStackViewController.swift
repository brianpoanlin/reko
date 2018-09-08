//
//  CardStackViewController.swift
//  reko
//
//  Created by Brian Lin on 9/8/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit

class CardStackViewController: UIViewController {
    
    private var stack = [CardsView(viewModel: CardsViewModel()), CardsView(viewModel: CardsViewModelYellow()), CardsView(viewModel: CardsViewModelGreen()), CardsView(viewModel: CardsViewModelBlue()), CardsView(viewModel: CardsViewModelPurple())]
    private var focused: Bool = false
    private var originalPosition: CGPoint!
    private var focusedTag: Int!
    private let socket = Socket()
    
    var maskView = UIView()

    private init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
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
        setupView()
        setupConstraint()
    }
    
    private func setupView() {
        stack.forEach({
            view.addSubview($0)
            $0.delegate = self
        })
    }
    
    private func setupConstraint() {
        stack[0].translatesAutoresizingMaskIntoConstraints = false
        stack[0].widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -20).isActive = true
        stack[0].heightAnchor.constraint(equalToConstant: 200).isActive = true
        stack[0].topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        stack[0].centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stack[0].categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        stack[0].categoryLabel.topAnchor.constraint(equalTo: stack[0].topAnchor, constant: 20).isActive = true
        stack[0].categoryLabel.leadingAnchor.constraint(equalTo: stack[0].leadingAnchor, constant: 20).isActive = true
        
        stack[0].titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stack[0].titleLabel.topAnchor.constraint(equalTo: stack[0].categoryLabel.bottomAnchor, constant: 10).isActive = true
        stack[0].titleLabel.leadingAnchor.constraint(equalTo: stack[0].leadingAnchor, constant: 20).isActive = true

        
        for i in 1..<stack.count {
            stack[i].translatesAutoresizingMaskIntoConstraints = false
            stack[i].widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -20).isActive = true
            stack[i].heightAnchor.constraint(equalToConstant: 200).isActive = true
            stack[i].topAnchor.constraint(equalTo: stack[i-1].topAnchor, constant: 40).isActive = true
            stack[i].centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            stack[i].categoryLabel.translatesAutoresizingMaskIntoConstraints = false
            stack[i].categoryLabel.topAnchor.constraint(equalTo: stack[i].topAnchor, constant: 20).isActive = true
            stack[i].categoryLabel.leadingAnchor.constraint(equalTo: stack[i].leadingAnchor, constant: 20).isActive = true
            
            stack[i].titleLabel.translatesAutoresizingMaskIntoConstraints = false
            stack[i].titleLabel.topAnchor.constraint(equalTo: stack[i].categoryLabel.bottomAnchor, constant: 10).isActive = true
            stack[i].titleLabel.leadingAnchor.constraint(equalTo: stack[i].leadingAnchor, constant: 20).isActive = true
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
            socket.sendUpdate()
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
    
}
