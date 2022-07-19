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
}
