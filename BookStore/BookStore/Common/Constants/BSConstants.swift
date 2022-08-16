//
//  BSConstants.swift
//  BookStore
//
//  Created by Group D on 18/07/22.
//

import Foundation


enum AppStoryboard: String {
    case login = "Main"
    case home = "Home"
    case profile = "Profile"
    case checkout = "Checkout"
}

enum UserDefaultKeys: String {
    case authToken = "Authorization"
    case email = "Email_address"
    case name = "Full_name"
    case address = "User_address"
    case city = "User_city"
    case state = "User_state"
    case phone = "User_phone"
    case postal = "postal_code"
}
