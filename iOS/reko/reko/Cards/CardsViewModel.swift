//
//  CardsViewModel.swift
//  reko
//
//  Created by Brian Lin on 9/7/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import Foundation

public protocol CardsViewModelProtocol {
    var category: String { get set }
    var title: String { get set }
    var description: String { get set }
}

public class CardsViewModel: CardsViewModelProtocol {
    public var category: String
    
    public var title: String
    
    public var description: String
    
    public init() {
        self.category = "Education"
        self.title = "My Education"
        self.description = "description"
    }
}
