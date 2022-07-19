//
//  ErrorModel.swift
//  BookStore
//
//  Created by Group D on 19/07/22.
//

import Foundation


struct ErrorModel: Codable {
    
    let status: String?
    let message: String?
    
    init(_ status: String,_ msg: String)
    {
        self.status = status
        self.message = msg
    }
}
