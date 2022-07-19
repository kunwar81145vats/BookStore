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
        
        let obj = HomeTabBarViewController.instantiate(appStoryboard: .home)
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        
        if nameTextField.text?.replacingOccurrences(of: " ", with: "").count == 0
        {
            let dialogMessage = UIAlertController(title: "Alert", message: "Please enter your full name", preferredStyle: .alert)
            dialogMessage.addAction(UIAlertAction.init(title: "OK", style: .default))
            self.present(dialogMessage, animated: true, completion: nil)

            return
        }
        
        if emailTextField.text?.count == 0
        {
            let dialogMessage = UIAlertController(title: "Alert", message: "Please enter your email address", preferredStyle: .alert)
            dialogMessage.addAction(UIAlertAction.init(title: "OK", style: .default))
            self.present(dialogMessage, animated: true, completion: nil)

            return
        }
        
        if passwordTextField.text?.count ?? 0 < 8
        {
            let dialogMessage = UIAlertController(title: "Alert", message: "Please enter a password", preferredStyle: .alert)
            dialogMessage.addAction(UIAlertAction.init(title: "OK", style: .default))
            self.present(dialogMessage, animated: true, completion: nil)
            
            return
        }
        if passwordTextField.text != confirmPasswordTextField.text
        {
            let dialogMessage = UIAlertController(title: "Alert", message: "Confirm password does not match with the password", preferredStyle: .alert)
            dialogMessage.addAction(UIAlertAction.init(title: "OK", style: .default))
            self.present(dialogMessage, animated: true, completion: nil)

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
        APIHelper.shared.signUp(param) { response, error in
            guard let resp = response, error == nil else
            {
                if let err = error
                {
                    let dialogMessage = UIAlertController(title: "Error", message: err.message, preferredStyle: .alert)
                    dialogMessage.addAction(UIAlertAction.init(title: "OK", style: .default))
                    self.present(dialogMessage, animated: true, completion: nil)
                }
                return
            }
            
            SharedSingleton.shared.user = resp
            
            let obj = HomeTabBarViewController.instantiate(appStoryboard: .home)
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
}
