//
//  Book.swift
//  BookStore
//
//  Created by Group D on 01/08/22.
//

import Foundation

struct Book: Codable {

    var bookId: Int!
    var title: String!
    var category: String?
    var author: String!
    var price: Double!
    var summary: String!
    var quantity: Int!
    var coverImageURL: String!
    var coordinateX: String!
    var coordinateY: String!
    var isFav: Bool? = false
}
