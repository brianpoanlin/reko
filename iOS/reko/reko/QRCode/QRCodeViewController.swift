//
//  QRCodeViewController.swift
//  reko
//
//  Created by Brian Lin on 9/7/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit
import QRCodeGenerator

class QRCodeViewController: UIViewController {

    fileprivate var qrCodeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    fileprivate var instructionLabel: UILabel = UILabel()
    fileprivate var qrcodeString: String = ""
    
    public init() {

        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
    }
    
    public convenience init(withContent content: String) {
        self.init()
        instructionLabel.text = content
        self.qrcodeString = content
        qrCodeImageView.image = RekoCodeGenerator.generatedQRCode(withCode: qrcodeString, size: qrCodeImageView.frame.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setUpConstraints()
    }
    
    private func setUpViews() {
        instructionLabel.textAlignment = .center
        
        view.addSubview(qrCodeImageView)
        view.addSubview(instructionLabel)
    }
    
    private func setUpConstraints() {
        qrCodeImageView.translatesAutoresizingMaskIntoConstraints = false
        qrCodeImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        qrCodeImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        qrCodeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        qrCodeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let margins = view.layoutMarginsGuide
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20).isActive = true
        instructionLabel.leadingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 20).isActive = true
        instructionLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
