//
//  CardStackViewController.swift
//  reko
//
//  Created by Brian Lin on 9/8/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit

class CardStackViewController: UIViewController {
    
    private var stack = [CardsView(viewModel: CardsViewModel()), CardsView(viewModel: CardsViewModelBlue()), CardsView(viewModel: CardsViewModelGreen()), CardsView(viewModel: CardsViewModelBlue())]
    private var focused: Bool = false
    private var originalPosition: CGPoint!
    private var focusedCard: CardsView!
    
    var maskView = UIView()

    private init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
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
        DispatchQueue.main.async {
            self.stack.forEach({
                $0.removeFromSuperview()
            })
        }
        
//        viewDidLoad()
    }

}

extension CardStackViewController: CardsViewDelegate {
    func swipedDown(sender: CardsView) {
        print("Dismiss")
        if focused {
            maskView.removeFromSuperview()
            focused = false
            
            UIView.animate(withDuration: 0.2, animations: {
                sender.transform = CGAffineTransform(translationX: 0.0, y: 200.0)
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
    
    func swipedUp(sender: CardsView) {
        print("Swiped up!!!!!")
        if focused {
            UIView.animate(withDuration: 0.4, animations: {
                sender.center = CGPoint(x: sender.center.x, y: sender.center.y - 600)
                self.maskView.alpha = 0
            }, completion: { bool in
                self.maskView.removeFromSuperview()
                sender.removeFromSuperview()
            })
            
            focused = false
        }
    }
    
    func tapped(sender: CardsView) {
        if !focused {
            focused = true
            maskView = UIView(frame: self.view.frame)
            maskView.backgroundColor = .black
            
            view.addSubview(maskView)
            view.bringSubview(toFront: sender)
            self.maskView.alpha = 0.5

            originalPosition = sender.center
            

            UIView.animate(withDuration: 0.4, animations: {
                let translation = self.view.frame.height / 2 - sender.center.y
                sender.transform = CGAffineTransform(translationX: 0.0, y: translation)
            })
            

        }
    }
    
}
