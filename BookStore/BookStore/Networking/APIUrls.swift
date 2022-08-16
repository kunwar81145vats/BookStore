//
//  APIUrls.swift
//  BookStore
//
//  Created by Group D on 19/07/22.
//

import Foundation

let isProd = false

let devBaseUrl = "https://b158-72-140-74-147.ngrok.io"
let prodBaseUrl = ""

struct Api {

    static let signUp = "/api/User/signup"
    static let signIn = "/api/User/signin"
    static let updateProfile = "/api/User"
    static let getBooks = "/api/Book"
    static let searchBooks = "/api/Book/search"
    static let cart = "api/Cart"
    static let orders = "/api/Order"
}
