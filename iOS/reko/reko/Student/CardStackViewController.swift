//
//  CardStackViewController.swift
//  reko
//
//  Created by Brian Lin on 9/8/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit

class CardStackViewController: UIViewController {
    
    private var stack = [CardsView(viewModel: CardsViewModel()), CardsView(viewModel: CardsViewModel()), CardsView(viewModel: CardsViewModel())]
    
    private init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
    }
    
    public convenience init(withStack stackToUse: [CardsView]) {
        self.init()
        print(stackToUse)
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
        stack.forEach({ view.addSubview($0) })
    }
    
    private func setupConstraint() {
        stack[0].translatesAutoresizingMaskIntoConstraints = false
        stack[0].widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -20).isActive = true
        stack[0].heightAnchor.constraint(equalToConstant: 200).isActive = true
        stack[0].topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        stack[0].centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        
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

}
