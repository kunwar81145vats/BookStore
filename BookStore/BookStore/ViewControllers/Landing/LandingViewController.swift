//
//  LandingViewController.swift
//  BookStore
//
//  Created by Group D on 18/07/22.
//

import UIKit

class LandingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func getStartedButtonAction(_ sender: Any) {
        
        self.navigationController?.isNavigationBarHidden = true
        let obj = SignUpViewController.instantiate(appStoryboard: .login)
        self.navigationController?.pushViewController(obj, animated: true)
    }

}
