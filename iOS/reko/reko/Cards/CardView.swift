//
//  CardView.swift
//  reko
//
//  Created by Brian Lin on 9/7/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit

public class CardsView: UIView {
    
    private var viewModel: CardsViewModelProtocol =  CardsViewModel()
    public var titleLabel: UILabel = UILabel()
    public var categoryLabel: UILabel = UILabel()

    
    private init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    }
    
    public convenience init(viewModel: CardsViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
        
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
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
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
