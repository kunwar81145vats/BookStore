//
//  APIServices.swift
//  BookStore
//
//  Created by Group D on 19/07/22.
//

import Foundation
import Moya


enum BSServices {
    case signUp(_ param: [String: String])
    case signIn(_ param: [String: String])
    case getBooks
    case searchBooks(_ search: String)
    case bookDetails(_ param: [String: String])
    case getCart
    case removeBookFromCart(_ bookId: Int)
    case addBookToCart(_ bookId: Int, _ count: Int)
    case updateBookinCart(_ bookId: Int, _ count: Int)
    case updateProfile(_ param: [String: String])
    case placeOrder(_ param: [String: Any])
    case getOrders
}



extension BSServices: TargetType {
    var method: Moya.Method {
        switch self {
            
        case .getBooks, .searchBooks, .bookDetails, .getCart, .getOrders:
            return .get
            
        case .updateBookinCart(_, _), .updateProfile(_):
            return .put
            
        case .removeBookFromCart(_):
            return .delete
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        //used for testing
        switch self {
        default:
            return "return sample parameters for testing".utf8Encoded
        }
    }
    
    var baseURL: URL { return URL(string: isProd ? prodBaseUrl : devBaseUrl)! }
    var path: String {
        switch self {
        case .signIn(_):
            return Api.signIn
        case .signUp(_):
            return Api.signUp
        case .getBooks:
            return Api.getBooks
        case .searchBooks(let search):
            return Api.searchBooks + "/\(search)"
        case .bookDetails(_):
            return Api.getBooks
        case .getCart:
            return Api.cart
        case .addBookToCart(let bookId, let count):
            return Api.cart + "/\(bookId)/\(count)"
        case .removeBookFromCart(let bookId):
            return Api.cart + "/\(bookId)"
        case .updateBookinCart(let bookId, let count):
            return Api.cart + "/\(bookId)/\(count)"
        case .updateProfile(_):
            return Api.updateProfile
        case .placeOrder(_):
            return Api.orders
        case .getOrders:
            return Api.orders
        }
    }
    
    var task: Task {
        switch self {
        case .signIn(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .signUp(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .getBooks:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .searchBooks(_):
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .bookDetails(let param):
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case .getCart:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .removeBookFromCart(_):
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .addBookToCart(_,_):
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .updateBookinCart(_, _):
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .updateProfile(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .placeOrder(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .getOrders:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        
        switch self {
        case .removeBookFromCart(_), .addBookToCart(_,_), .updateBookinCart(_,_), .getCart, .updateProfile(_), .getOrders, .placeOrder(_):
                return ["Content-type" : "application/json",
                        "Authorization": "Bearer " + SharedSingleton.shared.getAuthToken()]
            default:
                return ["Content-type": "application/json"]
        }
    }
}


// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

