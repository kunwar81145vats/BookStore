//
//  Order.swift
//  BookStore
//
//  Created by Kunwar Vats on 16/08/22.
//

import UIKit

class Order: Codable {

    let orderId: Int!
    let owner: User!
    let listBooks: [Book]!
    let totalPrice: Double!
    let date: String!
}
