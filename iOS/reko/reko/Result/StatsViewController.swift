//
//  StatsViewController.swift
//  reko
//
//  Created by Brian Lin on 9/9/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit
import UICircularProgressRing
import Charts
import SwiftyJSON

class StatsViewController: UIViewController {

    private let topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    private let progressRing = UICircularProgressRing(frame: CGRect(x: 0, y: 0, width: 240, height: 240))
    private var scrollView: UIScrollView!
    private var data: JSON!
    
    public convenience init(withData: JSON) {
        self.init()
        self.data = withData
        print(data)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.reko.purple.color()
        scrollView = UIScrollView(frame: self.view.frame)
        view.addSubview(scrollView)
        
        progressRing.maxValue = 100
        progressRing.innerRingColor = UIColor.reko.green.color()
        progressRing.innerRingWidth = 20
        progressRing.outerRingColor = UIColor.white
        progressRing.outerRingWidth = 20
        progressRing.fontColor = .white
        progressRing.font = UIFont(name: "Helvetica Neue", size: 24.0)!
        
        [topLabel, progressRing].forEach { scrollView.addSubview($0) }
        
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(data["jobMatchProb"])
        progressRing.startProgress(to: CGFloat(data["jobMatchProb"].intValue), duration: 1) {
            print("Done animating!")
            // Do anything your heart desires...
        }
    }
    
    private func setupConstraints() {
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1200)
//        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        topLabel.text = "Match Results"
        topLabel.font = UIFont(name: "Helvetica Neue", size: 34)
        topLabel.textAlignment = .center
        topLabel.textColor = .white
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 80).isActive = true
        topLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        topLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        progressRing.translatesAutoresizingMaskIntoConstraints = false
        progressRing.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 50).isActive = true
        progressRing.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        progressRing.heightAnchor.constraint(equalToConstant: 250).isActive = true
        progressRing.widthAnchor.constraint(equalToConstant: 250).isActive = true

        let label1 = UILabel()
        scrollView.addSubview(label1)
        label1.text = CardType.Awards.rawValue
        label1.textColor = .white
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.topAnchor.constraint(equalTo: progressRing.bottomAnchor, constant: 80).isActive = true
        label1.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        
        var obj: JSON = data[CardType.Awards.abbreviationLowercase]
        let chart1 = LineChart(compare: CGFloat(obj["s"].floatValue), candidate: CGFloat(obj["a"].floatValue))
        scrollView.addSubview(chart1)
        chart1.translatesAutoresizingMaskIntoConstraints = false
        chart1.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 5).isActive = true
        chart1.widthAnchor.constraint(equalToConstant: 300).isActive = true
        chart1.heightAnchor.constraint(equalToConstant: 40).isActive = true
        chart1.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        chart1.setupConstraints(new_width: 300)
        
        let label2 = UILabel()
        scrollView.addSubview(label2)
        label2.text = CardType.Coursework.rawValue
        label2.textColor = .white
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.topAnchor.constraint(equalTo: chart1.bottomAnchor, constant: 20).isActive = true
        label2.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        
        obj = data[CardType.Coursework.abbreviationLowercase]
        let chart2 = LineChart(compare: CGFloat(obj["s"].floatValue), candidate: CGFloat(obj["a"].floatValue))
        scrollView.addSubview(chart2)
        chart2.translatesAutoresizingMaskIntoConstraints = false
        chart2.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 5).isActive = true
        chart2.widthAnchor.constraint(equalToConstant: 300).isActive = true
        chart2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        chart2.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        chart2.setupConstraints(new_width: 300)
        
        let label3 = UILabel()
        scrollView.addSubview(label3)
        label3.text = CardType.Education.rawValue
        label3.textColor = .white
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.topAnchor.constraint(equalTo: chart2.bottomAnchor, constant: 20).isActive = true
        label3.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        
        obj = data[CardType.Education.abbreviationLowercase]
        let chart3 = LineChart(compare: CGFloat(obj["s"].floatValue), candidate: CGFloat(obj["a"].floatValue))
        scrollView.addSubview(chart3)
        chart3.translatesAutoresizingMaskIntoConstraints = false
        chart3.topAnchor.constraint(equalTo: label3.bottomAnchor, constant: 5).isActive = true
        chart3.widthAnchor.constraint(equalToConstant: 300).isActive = true
        chart3.heightAnchor.constraint(equalToConstant: 40).isActive = true
        chart3.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        chart3.setupConstraints(new_width: 300)
        
        let label4 = UILabel()
        scrollView.addSubview(label4)
        label4.text = CardType.Other.rawValue
        label4.textColor = .white
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.topAnchor.constraint(equalTo: chart3.bottomAnchor, constant: 20).isActive = true
        label4.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        
        obj = data[CardType.Other.abbreviationLowercase]
        let chart4 = LineChart(compare: CGFloat(obj["s"].floatValue), candidate: CGFloat(obj["a"].floatValue))
        scrollView.addSubview(chart4)
        chart4.translatesAutoresizingMaskIntoConstraints = false
        chart4.topAnchor.constraint(equalTo: label4.bottomAnchor, constant: 5).isActive = true
        chart4.widthAnchor.constraint(equalToConstant: 300).isActive = true
        chart4.heightAnchor.constraint(equalToConstant: 40).isActive = true
        chart4.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        chart4.setupConstraints(new_width: 300)
        
        let label6 = UILabel()
        scrollView.addSubview(label6)
        label6.text = CardType.Skills.rawValue
        label6.textColor = .white
        label6.translatesAutoresizingMaskIntoConstraints = false
        label6.topAnchor.constraint(equalTo: chart4.bottomAnchor, constant: 20).isActive = true
        label6.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        
        obj = data[CardType.Skills.abbreviationLowercase]
        let chart6 = LineChart(compare: CGFloat(obj["s"].floatValue), candidate: CGFloat(obj["a"].floatValue))
        scrollView.addSubview(chart6)
        chart6.translatesAutoresizingMaskIntoConstraints = false
        chart6.topAnchor.constraint(equalTo: label6.bottomAnchor, constant: 5).isActive = true
        chart6.widthAnchor.constraint(equalToConstant: 300).isActive = true
        chart6.heightAnchor.constraint(equalToConstant: 40).isActive = true
        chart6.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        chart6.setupConstraints(new_width: 300)
        
        let label7 = UILabel()
        scrollView.addSubview(label7)
        label7.text = CardType.Volunteering.rawValue
        label7.textColor = .white
        label7.translatesAutoresizingMaskIntoConstraints = false
        label7.topAnchor.constraint(equalTo: chart6.bottomAnchor, constant: 20).isActive = true
        label7.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        
        obj = data[CardType.Volunteering.abbreviationLowercase]
        let chart7 = LineChart(compare: CGFloat(obj["s"].floatValue), candidate: CGFloat(obj["a"].floatValue))
        scrollView.addSubview(chart7)
        chart7.translatesAutoresizingMaskIntoConstraints = false
        chart7.topAnchor.constraint(equalTo: label7.bottomAnchor, constant: 5).isActive = true
        chart7.widthAnchor.constraint(equalToConstant: 300).isActive = true
        chart7.heightAnchor.constraint(equalToConstant: 40).isActive = true
        chart7.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        chart7.setupConstraints(new_width: 300)
        
        let label8 = UILabel()
        scrollView.addSubview(label8)
        label8.text = CardType.WorkExperience.rawValue
        label8.textColor = .white
        label8.translatesAutoresizingMaskIntoConstraints = false
        label8.topAnchor.constraint(equalTo: chart7.bottomAnchor, constant: 20).isActive = true
        label8.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        
        obj = data[CardType.WorkExperience.abbreviationLowercase]
        let chart8 = LineChart(compare: CGFloat(obj["s"].floatValue), candidate: CGFloat(obj["a"].floatValue))
        scrollView.addSubview(chart8)
        chart8.translatesAutoresizingMaskIntoConstraints = false
        chart8.topAnchor.constraint(equalTo: label8.bottomAnchor, constant: 5).isActive = true
        chart8.widthAnchor.constraint(equalToConstant: 300).isActive = true
        chart8.heightAnchor.constraint(equalToConstant: 40).isActive = true
        chart8.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        chart8.setupConstraints(new_width: 300)
    }

}
