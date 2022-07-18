//
//  SignInViewController.swift
//  BookStore
//
//  Created by Group D on 18/07/22.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        let obj = HomeTabBarViewController.instantiate(appStoryboard: .home)
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func goToSignUpButtonAction(_ sender: Any) {
        
        if let controllers = self.navigationController?.viewControllers
        {
            if let obj = controllers.first(where: { controller in
                controller.isKind(of: SignUpViewController.self)
            })
            {
                self.navigationController?.popToViewController(obj, animated: true)
                return
            }
        }
        
        let obj = SignUpViewController.instantiate(appStoryboard: .login)
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
}
