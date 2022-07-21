//
//  BookDetailsViewController.swift
//  BookStore
//
//  Created by Group D on 21/07/22.
//

import UIKit

class BookDetailsViewController: UIViewController {

    @IBOutlet weak var addToCartButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addToCartButton.layer.borderColor = addToCartButton.tintColor.cgColor
        addToCartButton.layer.borderWidth = 1.0
        addToCartButton.layer.cornerRadius = 5
        
        self.navigationController?.isNavigationBarHidden = true
    }
    

    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}
