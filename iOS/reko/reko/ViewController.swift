//
//  ViewController.swift
//  reko
//
//  Created by Brian Lin on 9/7/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import UIKit
import QRCodeGenerator

class ViewController: UIViewController {

    override func viewWillDisappear(_ animated: Bool) {
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.red]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tappedStudent(_ sender: Any) {
        
//        let stack: [CardsView] = [CardsView(viewModel: CardsViewModel(type: CardType.PersonalInfo, elements: ["hunter", "lol"], id: 0))]
//        present(QRCodeViewController(withContent: "brianpoanlin.com"), animated: true, completion: nil)
//        present(CardStackViewController(withStack: stack), animated: true, completion: nil)
//        let navigationController = UINavigationController(rootViewController: QRCodeViewController(withContent: "brianlin.com"))
//        present(navigationController, animated: true, completion: nil)
        navigationController?.pushViewController(CardStackViewController(), animated: true)
//        navigationController?.pushViewController(QRCodeViewController(), animated: true)
    }
    
    @IBAction func tappedRecruiter(_ sender: Any) {
//        let navigationController = UINavigationController(rootViewController: QRScannerViewController())
        let navigationController = UINavigationController(rootViewController: RecruiterViewController())

        present(navigationController, animated: true, completion: nil)
    }
    
}
