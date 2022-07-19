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
}



extension BSServices: TargetType {
    var method: Moya.Method {
        switch self {
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
        }
    }
    
    var task: Task {
        switch self {
        case .signIn(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .signUp(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        
        switch self {
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

