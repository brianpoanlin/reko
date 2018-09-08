////
////  CardViews.swift
////  reko
////
////  Created by Brian Lin on 9/8/18.
////  Copyright © 2018 Brian Lin. All rights reserved.
////
//
//import UIKit
//
//public class PersonalInformationCard: CardsView {
//    public var name = UILabel()
//    public var email = UILabel()
//    public var phone = UILabel()
//    public var link = UILabel()
//    
//    public convenience init(name: String, email: String, phone: String, link: String) {
//        self.init(viewModel: CardsViewModelRed())
//        setupViews()
//    }
//    
//    public func setupViews() {
//        [name, email, phone, link].forEach({
//            addSubview($0)
//        })
//    }
//    
//    public override func setupSubviewConstraints() {
//        name.translatesAutoresizingMaskIntoConstraints = false
//        name.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
//        name.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
//        
//        email.translatesAutoresizingMaskIntoConstraints = false
//        email.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10).isActive = true
//        email.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
//        
//        phone.translatesAutoresizingMaskIntoConstraints = false
//        phone.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 10).isActive = true
//        phone.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
//        
//        link.translatesAutoresizingMaskIntoConstraints = false
//        link.topAnchor.constraint(equalTo: phone.bottomAnchor, constant: 10).isActive = true
//        link.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
//    }
//    
//
//}
