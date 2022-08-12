//
//  SignUpViewController.swift
//  BookStore
//
//  Created by Group D on 18/07/22.
//

import UIKit
import JGProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        
        let obj = HomeTabBarViewController.instantiate(appStoryboard: .home)
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        
        if let name = nameTextField.text?.replacingOccurrences(of: " ", with: ""), name.count == 0
        {
            SharedSingleton.shared.showErrorDialog(self, message: "Please enter your full name")
            return
        }
        
        if emailTextField.text?.count == 0
        {
            SharedSingleton.shared.showErrorDialog(self, message: "Please enter your email address")
            return
        }
        
        if passwordTextField.text?.count ?? 0 < 8
        {
            SharedSingleton.shared.showErrorDialog(self, message: "Please enter a password")
            return
        }
        if passwordTextField.text != confirmPasswordTextField.text
        {
            SharedSingleton.shared.showErrorDialog(self, message: "Confirm password does not match with the password")
            return
        }
        
        let param: [String: String] = ["fullName": nameTextField.text ?? "", "email": emailTextField.text ?? "", "password": passwordTextField.text ?? ""]
        sendSignUpRequest(param)
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
    
    func sendSignUpRequest(_ param: [String: String])
    {
        let hud = JGProgressHUD()
        hud.textLabel.text = ""
        hud.show(in: self.view)
        
        APIHelper.shared.signUp(param) { response, error in
            
            hud.dismiss()
            guard let resp = response, error == nil else
            {
                if let err = error
                {
                    SharedSingleton.shared.showErrorDialog(self, message: err.message)
                }
                return
            }
            
            SharedSingleton.shared.user = resp
            
            let obj = HomeTabBarViewController.instantiate(appStoryboard: .home)
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
}
