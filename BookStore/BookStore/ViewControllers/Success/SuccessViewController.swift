//
//  SuccessViewController.swift
//  BookStore
//
//  Created by Group D on 26/07/22.
//

import UIKit

class SuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .clear
        view.isOpaque = false
    }
    
    @IBAction func homeButtonAction(_ sender: Any) {
        
        let tabController = HomeTabBarViewController.instantiate(appStoryboard: .home)
        self.view.window?.rootViewController = tabController
    }
    
}
