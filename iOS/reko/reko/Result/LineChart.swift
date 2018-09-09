//
//  LineChart.swift
//  reko
//
//  Created by Brian Lin on 9/9/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit

class LineChart: UIView {
    
    public var width: CGFloat = 600.0
    public var compare: CGFloat!
    public var candidate: CGFloat!
    public var compareView: UIView!
    public var candidateView: UIView!

    public convenience init(compare: CGFloat, candidate: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: 200, height: 120))
        self.compare = compare
        self.candidate = candidate
        compareView = UIView(frame: CGRect(x: 0, y: 0, width: compare * width, height: 50))
        compareView.backgroundColor = .white
        candidateView = UIView(frame: CGRect(x: 0, y: 0, width: compare * width, height: 50))
        candidateView.backgroundColor = UIColor.reko.green.color()
        setupView()
    }
    
    private func setupView() {
        addSubview(compareView)
        addSubview(candidateView)
    }
    
    public func setupConstraints(new_width: CGFloat) {
        compareView.translatesAutoresizingMaskIntoConstraints = false
        compareView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        compareView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        compareView.widthAnchor.constraint(equalToConstant: compare * new_width / 100).isActive = true
        compareView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let labelCompare = UILabel()
        addSubview(labelCompare)
        labelCompare.text = String(format: "%.1f You", compare)
        labelCompare.textColor = .white
        labelCompare.font = UIFont(name: "Helvetica Neue", size: 12)
        labelCompare.translatesAutoresizingMaskIntoConstraints = false
        labelCompare.leftAnchor.constraint(equalTo: compareView.rightAnchor, constant: 10).isActive = true
        labelCompare.heightAnchor.constraint(equalToConstant: 20).isActive = true
        labelCompare.topAnchor.constraint(equalTo: compareView.topAnchor).isActive = true

        
        candidateView.translatesAutoresizingMaskIntoConstraints = false
        candidateView.topAnchor.constraint(equalTo: compareView.bottomAnchor).isActive = true
        candidateView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        candidateView.widthAnchor.constraint(equalToConstant: candidate * new_width / 100).isActive = true
        candidateView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let labelCandidate = UILabel()
        addSubview(labelCandidate)
        labelCandidate.text = String(format: "%.1f Avg", candidate)
        labelCandidate.textColor = .white
        labelCandidate.font = UIFont(name: "Helvetica Neue", size: 12)
        labelCandidate.translatesAutoresizingMaskIntoConstraints = false
        labelCandidate.leftAnchor.constraint(equalTo: candidateView.rightAnchor, constant: 10).isActive = true
        labelCandidate.heightAnchor.constraint(equalToConstant: 20).isActive = true
        labelCandidate.topAnchor.constraint(equalTo: candidateView.topAnchor).isActive = true
    }

}
