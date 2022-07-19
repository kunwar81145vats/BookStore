//
//  APIHelper.swift
//  BookStore
//
//  Created by Group D on 19/07/22.
//

import UIKit
import Moya
import Alamofire

class APIHelper {

    static let shared: APIHelper = APIHelper()

    func signUp(_ param: [String: String], completion: @escaping(_ response: [String: AnyObject]?,_ error: ErrorModel?) -> Void )
    {
        let provider = MoyaProvider<BSServices>()
        provider.request(.signUp(param)) { result in
            
            switch result {
            case .success(let response):
                print(response)
                
                if let json = try! JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] {
                    
                    print(json)
                }
                
                break
            case .failure(let error):
                print(error)
            }
        }
    }
}
