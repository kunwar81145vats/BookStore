//
//  SignUpViewController.swift
//  BookStore
//
//  Created by Group D on 18/07/22.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func skipButtonAction(_ sender: Any) {
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        
        let param = ["email": "kunwar@gmail.com", "fullName": "kunwar asd", "password": "Vaasdadts123#"]
        APIHelper.shared.signUp(param) { response, error in
            guard let resp = response, error == nil else { return }
            print(resp)
        }
//        let obj = HomeTabBarViewController.instantiate(appStoryboard: .home)
//        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func goToSignInButtonAction(_ sender: Any) {
        
        if let controllers = self.navigationController?.viewControllers
        {
            if let obj = controllers.first(where: { controller in
                controller.isKind(of: SignInViewController.self)
            })
            {
                self.navigationController?.popToViewController(obj, animated: true)
                return
            }
        }
        
        let obj = SignInViewController.instantiate(appStoryboard: .login)
        self.navigationController?.pushViewController(obj, animated: true)
    }
}
