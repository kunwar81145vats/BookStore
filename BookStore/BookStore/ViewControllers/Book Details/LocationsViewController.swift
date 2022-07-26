//
//  LocationsViewController.swift
//  BookStore
//
//  Created by Group D on 26/07/22.
//

import UIKit

class LocationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Store Locations"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
    }
}
