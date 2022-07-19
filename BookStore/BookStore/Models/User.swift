//
//  User.swift
//  BookStore
//
//  Created by Group D on 19/07/22.
//

import Foundation


struct User: Codable
{
    var fullName: String!
    var email: String!
    var phoneNumber: String?
    var address: String?
    var city: String?
    var state: String?
    var postalCode: String?
}
