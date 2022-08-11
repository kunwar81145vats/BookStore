//
//  APIUrls.swift
//  BookStore
//
//  Created by Group D on 19/07/22.
//

import Foundation

let isProd = false

let devBaseUrl = "https://c965-72-140-74-147.ngrok.io"
let prodBaseUrl = ""

struct Api {

    static let signUp = "/api/User/signup"
    static let signIn = "/api/User/signin"
    static let getBooks = "/api/Book"
    static let searchBooks = "/api/Book/search"
    static let cart = "/api/Cart"
}
