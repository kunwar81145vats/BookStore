//
//  Extensions.swift
//  BookStore
//
//  Created by Group D on 18/07/22.
//

import Foundation
import UIKit


extension UIViewController {

    class func instantiate<T: UIViewController>(appStoryboard: AppStoryboard) -> T {

        let storyboard = UIStoryboard(name: appStoryboard.rawValue, bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}
