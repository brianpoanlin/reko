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
    
    private var viewModel: CardsViewModelProtocol!
    public var titleLabel: UILabel = UILabel()
    public var categoryLabel: UILabel = UILabel()
    public var id: Int = 0
    public var labels = [UILabel]()
    
    public var delegate: CardsViewDelegate?
    
    private init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    }
    
    public convenience init(viewModel: CardsViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
        setupView()
        self.isUserInteractionEnabled = true
        id = viewModel.id
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
        
        backgroundColor = viewModel.category.color
        layer.cornerRadius = 30
        
        addSubview(categoryLabel)
        categoryLabel.text = viewModel.category.rawValue
        categoryLabel.textColor = .white
        categoryLabel.font = UIFont.init(name: "Helvetica Neue", size: 12)
        
        viewModel.elements.forEach({
            let label = UILabel()
            label.text = $0
            label.contentMode = .scaleToFill
            label.numberOfLines = 0
            label.textColor = .white
            label.font = UIFont.init(name: "Helvetica Neue", size: 18)

            labels.append(label)
        })
        
        labels.forEach({
            addSubview($0)
        })
        
//        addSubview(titleLabel)
//        titleLabel.text = viewModel.title
//        titleLabel.textColor = .white
//        titleLabel.font = UIFont.init(name: "Helvetica Neue", size: 18)
    }
    
    public func setupSubviewConstraints() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        labels[0].translatesAutoresizingMaskIntoConstraints = false
        labels[0].topAnchor.constraint(equalTo: categoryLabel.topAnchor, constant: 20).isActive = true
        labels[0].leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        labels[0].trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true

        
        for i in 1..<labels.count {
            labels[i].translatesAutoresizingMaskIntoConstraints = false
            labels[i].topAnchor.constraint(equalTo: labels[i-1].bottomAnchor, constant: 10).isActive = true
            labels[i].leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
            labels[i].trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true

        }

//
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10).isActive = true
//        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
    }

    @objc private func tapped() {
        delegate?.tapped(sender: self)
    }
    
    @objc private func swipedUp() {
        
        delegate?.swipedUp(sender: self)
    }
    
    @objc private func swipedDown() {
        delegate?.swipedDown(sender: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
