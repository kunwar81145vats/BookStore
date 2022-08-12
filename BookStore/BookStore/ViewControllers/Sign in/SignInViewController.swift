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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        
        let obj = HomeTabBarViewController.instantiate(appStoryboard: .home)
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        if emailTextField.text?.count == 0
        {
            let dialogMessage = UIAlertController(title: "Alert", message: "Please enter your email address", preferredStyle: .alert)
            dialogMessage.addAction(UIAlertAction.init(title: "OK", style: .default))
            self.present(dialogMessage, animated: true, completion: nil)

            return
        }
        
        if passwordTextField.text?.count ?? 0 < 8
        {
            let dialogMessage = UIAlertController(title: "Alert", message: "Please enter correct password", preferredStyle: .alert)
            dialogMessage.addAction(UIAlertAction.init(title: "OK", style: .default))
            self.present(dialogMessage, animated: true, completion: nil)
            
            return
        }
        
        let param: [String: String] = ["email": emailTextField.text ?? "", "password": passwordTextField.text ?? ""]
        sendSignInRequest(param)
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
    
    func sendSignInRequest(_ param: [String: String])
    {
        APIHelper.shared.signIn(param) { response, error in
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
