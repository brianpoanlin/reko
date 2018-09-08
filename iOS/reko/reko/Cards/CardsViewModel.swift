//
//  CardsViewModel.swift
//  reko
//
//  Created by Brian Lin on 9/7/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit

public protocol CardsViewModelProtocol {
    var category: String { get set }
    var title: String { get set }
    var description: String { get set }
    var color: UIColor { get set }
}

public class CardsViewModel: CardsViewModelProtocol {
    public var color: UIColor
    
    public var category: String
    
    public var title: String
    
    public var description: String
    
    public init() {
        self.category = "Education"
        self.title = "University of Michigan"
        self.description = "description"
        self.color = UIColor.reko.red.color()
    }
}

public class CardsViewModelBlue: CardsViewModelProtocol {
    public var color: UIColor
    
    public var category: String
    
    public var title: String
    
    public var description: String
    
    public init() {
        self.category = "Skill"
        self.title = "University of Michigan"
        self.description = "description"
        self.color = UIColor.blue
    }
}
