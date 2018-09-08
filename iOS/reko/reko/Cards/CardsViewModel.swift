//
//  CardsViewModel.swift
//  reko
//
//  Created by Brian Lin on 9/7/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit

public enum CardType {
    case PersonalInfo, Education, Skills, WorkExperience, Awards, Volunteering, Coursework, Other
    
    var color: UIColor {
        switch self {
        case .PersonalInfo:
            return UIColor.reko.magenta.color()
        case .Education:
            return UIColor.reko.green.color()
        case .Skills:
            return UIColor.reko.blue.color()
        case .WorkExperience:
            return UIColor.reko.orange.color()
        case .Awards:
            return UIColor.reko.yellow.color()
        case .Volunteering:
            return UIColor.reko.purple.color()
        case .Coursework:
            return UIColor.reko.pink.color()
        case .Other:
            return UIColor.reko.gray.color()
        }
    }
    
    var rawValue: String {
        switch self {
        case .PersonalInfo:
            return "Personal Information"
        case .Education:
            return "Education"
        case .Skills:
            return "Skills"
        case .WorkExperience:
            return "Work Experience"
        case .Awards:
            return "Awards"
        case .Volunteering:
            return "Volunteering"
        case .Coursework:
            return "Coursework"
        case .Other:
            return "Other"
        }
    }
}

public protocol CardsViewModelProtocol {
    var category: CardType { get set }
    var id: Int { get set }
    var elements: [String] { get set }
}

public class CardsViewModel: CardsViewModelProtocol {
    
    public var category: CardType
    public var elements: [String]
    public var id: Int
    
    public init(type: CardType, elements: [String], id: Int) {
        self.category = type
        self.elements = elements
        self.id = id
    }
    
}

//public class CardsViewModelRed: CardsViewModelProtocol {
//    public var elements: [UILabel]
//
//    public var color: UIColor
//
//    public var category: String
//
//    public var title: String
//
//    public var description: String
//    public var id: Int
//
//    public init() {
//        self.category = "Skill"
//        self.title = "University of Michigan"
//        self.description = "description"
//        self.color = UIColor.reko.red.color()
//        self.id = 3
//    }
//}
//
//public class CardsViewModelBlue: CardsViewModelProtocol {
//    public var elements: [UILabel]
//
//    public var color: UIColor
//
//    public var category: String
//
//    public var title: String
//
//    public var description: String
//    public var id: Int
//
//    public init() {
//        self.category = "Skill"
//        self.title = "University of Michigan"
//        self.description = "description"
//        self.color = UIColor.reko.blue.color()
//        self.id = 3
//
//    }
//}
//
//public class CardsViewModelGreen: CardsViewModelProtocol {
//    public var elements: [UILabel]
//
//    public var color: UIColor
//
//    public var category: String
//
//    public var title: String
//
//    public var description: String
//    public var id: Int
//
//    public init() {
//        self.category = "Education"
//        self.title = "University of Michigan"
//        self.description = "description"
//        self.color = UIColor.reko.green.color()
//        self.id = 4
//
//    }
//}
//
//public class CardsViewModelYellow: CardsViewModelProtocol {
//    public var elements: [UILabel]
//
//    public var color: UIColor
//
//    public var category: String
//
//    public var title: String
//
//    public var description: String
//    public var id: Int
//
//    public init() {
//        self.category = "Awards"
//        self.title = "MHacks X: Best Financial Hack"
//        self.description = "description"
//        self.color = UIColor.reko.yellow.color()
//        self.id = 5
//    }
//}
//
//public class CardsViewModelPurple: CardsViewModelProtocol {
//    public var elements: [UILabel]
//
//    public var color: UIColor
//
//    public var category: String
//
//    public var title: String
//
//    public var description: String
//    public var id: Int
//
//    public init() {
//        self.category = "Volunteering"
//        self.title = "YMCA every sunday"
//        self.description = "description"
//        self.color = UIColor.reko.purple.color()
//        self.id = 6
//    }
//}
//
//public class CardsViewModelMagenta: CardsViewModelProtocol {
//    public var elements: [UILabel]
//
//    public var color: UIColor
//
//    public var category: String
//
//    public var title: String
//
//    public var description: String
//    public var id: Int
//
//    public init() {
//        self.category = "Personal Information"
//        self.title = "harloff@umich.edu"
//        self.description = "description"
//        self.color = UIColor.reko.magenta.color()
//        self.id = 1
//    }
//}

