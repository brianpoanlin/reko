//
//  CardView.swift
//  reko
//
//  Created by Brian Lin on 9/7/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit

public protocol CardsViewDelegate {
    func tapped(sender: CardsView)
    func swipedDown(sender: CardsView)
    func swipedUp(sender: CardsView)
}

public class CardsView: UIView {
    
    private var viewModel: CardsViewModelProtocol =  CardsViewModel()
    public var titleLabel: UILabel = UILabel()
    public var categoryLabel: UILabel = UILabel()
    
    public var delegate: CardsViewDelegate?
    
    private init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    }
    
    public convenience init(viewModel: CardsViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
        setupView()
        setupConstraints()
        self.isUserInteractionEnabled = true

    }
    
    private func setupView() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tapRecognizer)
        
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp))
        swipeUpRecognizer.direction = .up
        self.addGestureRecognizer(swipeUpRecognizer)
        
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
        swipeDownRecognizer.direction = .down
        self.addGestureRecognizer(swipeDownRecognizer)
        
        backgroundColor = viewModel.color
        layer.cornerRadius = 30
        
        addSubview(categoryLabel)
        categoryLabel.text = viewModel.category
        categoryLabel.textColor = .white
        categoryLabel.font = UIFont.init(name: "Helvetica Neue", size: 12)
        
        addSubview(titleLabel)
        titleLabel.text = viewModel.title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.init(name: "Helvetica Neue", size: 18)
    }
    
    private func setupConstraints() {

//        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    @objc private func tapped() {
        print("Tapped!!!!!")

        delegate?.tapped(sender: self)
    }
    
    @objc private func swipedUp() {
        
        delegate?.swipedUp(sender: self)
    }
    
    @objc private func swipedDown() {
        print("Swiped down!!!!!")
        
        delegate?.swipedDown(sender: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
