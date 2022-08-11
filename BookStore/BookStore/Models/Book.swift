//
//  Book.swift
//  BookStore
//
//  Created by Group D on 01/08/22.
//

import Foundation

struct Book: Codable {

    let bookId: Int!
    let title: String!
    let category: String?
    let author: String!
    let price: Double!
    let summary: String!
    var quantity: Int!
    let coverImageURL: String!
    let coordinateX: String!
    let coordinateY: String!
}
