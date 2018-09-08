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
    var id: Int { get set }
}

public class CardsViewModel: CardsViewModelProtocol {
    public var color: UIColor
    
    public var category: String
    
    public var title: String
    
    public var description: String
    public var id: Int
    
    public init() {
        self.category = "Education"
        self.title = "University of Michigan"
        self.description = "description"
        self.color = UIColor.reko.red.color()
        self.id = 2

    }
}

public class CardsViewModelBlue: CardsViewModelProtocol {
    public var color: UIColor
    
    public var category: String
    
    public var title: String
    
    public var description: String
    public var id: Int

    public init() {
        self.category = "Skill"
        self.title = "University of Michigan"
        self.description = "description"
        self.color = UIColor.reko.blue.color()
        self.id = 3

    }
}

public class CardsViewModelGreen: CardsViewModelProtocol {
    public var color: UIColor
    
    public var category: String
    
    public var title: String
    
    public var description: String
    public var id: Int

    public init() {
        self.category = "Education"
        self.title = "University of Michigan"
        self.description = "description"
        self.color = UIColor.reko.green.color()
        self.id = 4

    }
}

public class CardsViewModelYellow: CardsViewModelProtocol {
    public var color: UIColor
    
    public var category: String
    
    public var title: String
    
    public var description: String
    public var id: Int

    public init() {
        self.category = "Awards"
        self.title = "MHacks X: Best Financial Hack"
        self.description = "description"
        self.color = UIColor.reko.yellow.color()
        self.id = 5
    }
}

public class CardsViewModelPurple: CardsViewModelProtocol {
    public var color: UIColor
    
    public var category: String
    
    public var title: String
    
    public var description: String
    public var id: Int
    
    public init() {
        self.category = "Volunteering"
        self.title = "YMCA every sunday"
        self.description = "description"
        self.color = UIColor.reko.purple.color()
        self.id = 6
    }
}

