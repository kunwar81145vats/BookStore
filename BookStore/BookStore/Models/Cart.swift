//
//  Cart.swift
//  BookStore
//
//  Created by Kunwar Vats on 10/08/22.
//

import UIKit

struct Cart: Codable {

    let id: Int!
    var books: [Book]?
    
    enum CodingKeys: String, CodingKey {
        case id = "cartId"
        case books = "listBooks"
    }
}
