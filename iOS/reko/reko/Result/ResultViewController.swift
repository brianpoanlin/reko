//
//  ResultViewController.swift
//  reko
//
//  Created by Brian Lin on 9/9/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit
import UICircularProgressRing

class ResultViewController: UIViewController {
    
    private let progressRing = UICircularProgressRing(frame: CGRect(x: 0, y: 0, width: 240, height: 240))
    private let topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    private let endSessionButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    private let client = Socket()

    private var target: Int!

    public convenience init(withTarget max: Int) {
        self.init()
        self.target = max
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.reko.purple.color()

        progressRing.maxValue = 100
        progressRing.innerRingColor = UIColor.reko.green.color()
        progressRing.innerRingWidth = 20
        progressRing.outerRingColor = UIColor.white
        progressRing.outerRingWidth = 20
        progressRing.fontColor = .white
        progressRing.font = UIFont(name: "Helvetica Neue", size: 24.0)!

        view.addSubview(progressRing)
        view.addSubview(topLabel)
        view.addSubview(endSessionButton)
        
        endSessionButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        
        client.connect()
        
        setupConstraints()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupConstraints() {
        progressRing.translatesAutoresizingMaskIntoConstraints = false
        progressRing.widthAnchor.constraint(equalToConstant: 300).isActive = true
        progressRing.heightAnchor.constraint(equalToConstant: 300).isActive = true
        progressRing.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressRing.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        topLabel.text = "Match Results"
        topLabel.textAlignment = .center
        topLabel.textColor = UIColor.white
        topLabel.font = UIFont(name: "Helvetica Neue", size: 36)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        endSessionButton.setTitle("Send Student", for: .normal)
        endSessionButton.setTitleColor(.white, for: .normal)
        endSessionButton.setTitleColor(UIColor.reko.purple.color(), for: .highlighted)
        endSessionButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        endSessionButton.backgroundColor = .clear
        endSessionButton.layer.borderWidth = 1
        endSessionButton.layer.borderColor = UIColor.white.cgColor
        endSessionButton.layer.cornerRadius = 5
        endSessionButton.translatesAutoresizingMaskIntoConstraints = false
        endSessionButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        endSessionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        endSessionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        progressRing.startProgress(to: CGFloat(target), duration: 1) {
            print("Done animating!")
            // Do anything your heart desires...
        }
    }
    
    @objc
    private func handleTap() {
        client.sendStats()
        self.dismiss(animated: true, completion: nil)
    }

}
