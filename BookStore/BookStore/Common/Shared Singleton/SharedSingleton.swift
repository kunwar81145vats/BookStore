//
//  SharedSingleton.swift
//  BookStore
//
//  Created by Group D on 19/07/22.
//

import UIKit

class SharedSingleton: NSObject {

    static let shared: SharedSingleton = SharedSingleton()
    
    var user: User?
    var cart: Cart?
    
    private override init() {}
    
    func showErrorDialog(_ vc: UIViewController, message: String? = "Something went wrong")
    {
        let dialogMessage = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        dialogMessage.addAction(UIAlertAction.init(title: "OK", style: .default))
        vc.present(dialogMessage, animated: true, completion: nil)
    }
    
    func showLoginDialog(_ vc: UIViewController, message: String? = "Please login")
    {
        let dialogMessage = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        dialogMessage.addAction(UIAlertAction.init(title: "Go to Login", style: .default, handler: { action in
            
            let obj = SignInViewController.instantiate(appStoryboard: .login)
            vc.navigationController?.pushViewController(obj, animated: true)
        }))
        dialogMessage.addAction(UIAlertAction.init(title: "Cancel", style: .cancel))
        vc.present(dialogMessage, animated: true, completion: nil)
    }
    
    func getAuthToken() -> String
    {
        return UserDefaults.standard.string(forKey: UserDefaultKeys.authToken.rawValue) ?? ""
    }
    
    func saveAuthToken(_ token: String)
    {
        UserDefaults.standard.set(token, forKey: UserDefaultKeys.authToken.rawValue)
    }
    
    func deleteAuthToken()
    {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.authToken.rawValue)
    }
}
