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
    
    private override init() {}
    
    func showErrorDialog(_ vc: UIViewController, message: String? = "Something went wrong")
    {
        let dialogMessage = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        dialogMessage.addAction(UIAlertAction.init(title: "OK", style: .default))
        vc.present(dialogMessage, animated: true, completion: nil)
    }
}
