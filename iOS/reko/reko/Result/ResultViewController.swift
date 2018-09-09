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
    private let bottomLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
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

        view.addSubview(progressRing)
        view.addSubview(topLabel)
        view.addSubview(bottomLabel)
        
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
        
        topLabel.text = "Results"
        topLabel.textAlignment = .center
        topLabel.textColor = UIColor.white
        topLabel.font = UIFont(name: "Helvetica Neue", size: 36)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        bottomLabel.text = "Compatiility for Position"
        bottomLabel.textColor = UIColor.white
        topLabel.textAlignment = .center
        bottomLabel.font = UIFont(name: "Helvetica Neue", size: 28)
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        bottomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        progressRing.startProgress(to: CGFloat(target), duration: 1) {
            print("Done animating!")
            // Do anything your heart desires...
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
