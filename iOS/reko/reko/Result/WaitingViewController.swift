//
//  WaitingViewController.swift
//  reko
//
//  Created by Brian Lin on 9/9/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit
import UICircularProgressRing
import SwiftyJSON

class WaitingViewController: UIViewController {

    private let topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    private let bottomLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    private let progressRing = UICircularProgressRing(frame: CGRect(x: 0, y: 0, width: 240, height: 240))
    
    private let client = Socket()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.reko.orange.color()

        progressRing.maxValue = 100
        progressRing.innerRingColor = UIColor.reko.blue.color()
        progressRing.innerRingWidth = 20
        progressRing.outerRingColor = UIColor.white
        progressRing.outerRingWidth = 20
        progressRing.fontColor = .clear
        progressRing.font = UIFont(name: "Helvetica Neue", size: 24.0)!
        
        view.addSubview(topLabel)
        view.addSubview(progressRing)
        view.addSubview(bottomLabel)
        
        client.connect()
        client.delegate = self
        
        setupConstraints()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupConstraints() {
        topLabel.text = "You're Done!"
        topLabel.numberOfLines = 0
        topLabel.textAlignment = .center
        topLabel.textColor = UIColor.white
        topLabel.font = UIFont(name: "Helvetica Neue", size: 36)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        
        progressRing.translatesAutoresizingMaskIntoConstraints = false
        progressRing.widthAnchor.constraint(equalToConstant: 300).isActive = true
        progressRing.heightAnchor.constraint(equalToConstant: 300).isActive = true
        progressRing.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressRing.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        bottomLabel.text = "Please Wait."
        bottomLabel.numberOfLines = 0
        bottomLabel.textAlignment = .center
        bottomLabel.textColor = UIColor.white
        bottomLabel.font = UIFont(name: "Helvetica Neue", size: 36)
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        
    }

    override func viewDidAppear(_ animated: Bool) {
        progressRing.startProgress(to: 100, duration: 50) {
            print("Done animating!")
            // Do anything your heart desires...
        }
    }

}

extension WaitingViewController: SocketDelegate {
    func statsReceived(data: [Any]) {
        let json: JSON = JSON(arrayLiteral: data.first)
        print(json)
        
        if let array: [JSON] = json.array {
            if let employment = array.first {
                print(employment["employment"])
                let data = employment["employment"]
                
                let num = data["jobMatchProb"].intValue
                present(StatsViewController(withData: data), animated: true, completion: nil)
            }
        }
    }
    
    func receivedNewCard(data: [Any]) {
        
    }
    
    func receivedCardStack(data: [Any]) {
        
    }
    
    func startedSession() {
        
    }
    
    func endedSession(data: [Any]) {
        
    }
}
