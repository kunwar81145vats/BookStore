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

    //MARK: - Save Auth Token
    func saveAuthToken(response: HTTPURLResponse?)
    {
        let responseHeaderDictionary = response?.allHeaderFields
        
        if let token = responseHeaderDictionary?["Authorization"] as? String
        {
            UserDefaults.standard.set(token, forKey: UserDefaultKeys.authToken.rawValue)
        }
    }
    
    //MARK: - Sign up APi
    //API method to register a new user
    func signUp(_ param: [String: String], completion: @escaping(_ response: User?,_ error: ErrorModel?) -> Void )
    {
        let provider = MoyaProvider<BSServices>()
        provider.request(.signUp(param)) { result in
            
            switch result {
            case .success(let response):
                
                do {
                    let userObj = try JSONDecoder().decode(User.self, from: response.data)
                    let response = response.response
                    self.saveAuthToken(response: response)
                    completion(userObj, nil)
                }
                catch let err
                {
                    completion(nil, ErrorModel.init("500", err.localizedDescription))
                }

                break
            case .failure(let error):
                print(error)
                completion(nil, ErrorModel.init("500", error.localizedDescription))
            }
        }
    }
    
    //MARK: - Sign In API
    //API method to sign in the user
    func signIn(_ param: [String: String], completion: @escaping(_ response: User?,_ error: ErrorModel?) -> Void )
    {
        let provider = MoyaProvider<BSServices>()
        provider.request(.signIn(param)) { result in
            
            switch result {
            case .success(let response):

                do {
                    let userObj = try JSONDecoder().decode(User.self, from: response.data)

                    let response = response.response
                    self.saveAuthToken(response: response)
                    completion(userObj, nil)
                }
                catch let err
                {
                    completion(nil, ErrorModel.init("500", err.localizedDescription))
                }

                break
            case .failure(let error):
                print(error)
                completion(nil, ErrorModel.init("500", error.localizedDescription))
            }
        }
    }
    
    //MARK: - Get Books
    //API method to get all books
    func getBooks(completion: @escaping(_ response: [Book]?,_ error: ErrorModel?) -> Void )
    {
        let provider = MoyaProvider<BSServices>()
        provider.request(.getBooks) { result in
            
            switch result {
            case .success(let response):
                
                do {
                    let userObj = try JSONDecoder().decode([Book].self, from: response.data)
                    let response = response.response
                    self.saveAuthToken(response: response)
                    completion(userObj, nil)
                }
                catch let err
                {
                    completion(nil, ErrorModel.init("500", err.localizedDescription))
                }

                break
            case .failure(let error):
                print(error)
                completion(nil, ErrorModel.init("500", error.localizedDescription))
            }
        }
    }
    
    //MARK: - Search Books
    //API method to search books
    func searchBooks(_ search: String, completion: @escaping(_ response: [Book]?,_ error: ErrorModel?) -> Void )
    {
        let provider = MoyaProvider<BSServices>()
        provider.request(.searchBooks(search)) { result in
            
            switch result {
            case .success(let response):
                
                do {
                    let userObj = try JSONDecoder().decode([Book].self, from: response.data)
                    let response = response.response
                    self.saveAuthToken(response: response)
                    completion(userObj, nil)
                }
                catch let err
                {
                    completion(nil, ErrorModel.init("500", err.localizedDescription))
                }

                break
            case .failure(let error):
                print(error)
                completion(nil, ErrorModel.init("500", error.localizedDescription))
            }
        }
    }
    
    //MARK: - Get Book Details
    //API method to get book details
    func getBookDetails(_ param: [String: String], completion: @escaping(_ response: Book?,_ error: ErrorModel?) -> Void )
    {
        let provider = MoyaProvider<BSServices>()
        provider.request(.bookDetails(param)) { result in
            
            switch result {
            case .success(let response):

                do {
                    let userObj = try JSONDecoder().decode(Book.self, from: response.data)
                    let response = response.response
                    self.saveAuthToken(response: response)
                    completion(userObj, nil)
                }
                catch let err
                {
                    completion(nil, ErrorModel.init("500", err.localizedDescription))
                }

                break
            case .failure(let error):
                print(error)
                completion(nil, ErrorModel.init("500", error.localizedDescription))
            }
        }
    }
    
    //MARK: - Get Cart Details
    //API method to get cart details
    func getCartDetails(completion: @escaping(_ response: Cart?,_ error: ErrorModel?) -> Void )
    {
        let provider = MoyaProvider<BSServices>()
        provider.request(.getCart) { result in
            
            switch result {
            case .success(let response):

                do {
                    let Obj = try JSONDecoder().decode(Cart.self, from: response.data)
                    completion(Obj, nil)
                }
                catch let err
                {
                    completion(nil, ErrorModel.init("999", err.localizedDescription))
                }

                break
            case .failure(let error):
                print(error)
                completion(nil, ErrorModel.init("500", error.localizedDescription))
            }
        }
    }
    
    //MARK: - Insert Book in Cart
    //API method to insert Book in Cart
    func insertBookinCart(_ bookId: Int, completion: @escaping(_ response: Cart?,_ error: ErrorModel?) -> Void )
    {
        let provider = MoyaProvider<BSServices>()
        provider.request(.addBookToCart(bookId, 1)) { result in
            
            switch result {
            case .success(let response):
                
                do {
                    let Obj = try JSONDecoder().decode(Cart.self, from: response.data)
                    completion(Obj, nil)
                }
                catch let err
                {
                    completion(nil, ErrorModel.init("500", err.localizedDescription))
                }

                break
            case .failure(let error):
                print(error)
                completion(nil, ErrorModel.init("500", error.localizedDescription))
            }
        }
    }
    
    
    //MARK: - Remove Book in Cart
    //API method to remove Book in Cart
    func removeBookinCart(_ bookId: Int, completion: @escaping(_ response: Cart?,_ error: ErrorModel?) -> Void )
    {
        let provider = MoyaProvider<BSServices>()
        provider.request(.removeBookFromCart(bookId)) { result in
            
            switch result {
            case .success(let response):
                
                do {
                    let Obj = try JSONDecoder().decode(Cart.self, from: response.data)
                    completion(Obj, nil)
                }
                catch let err
                {
                    completion(nil, ErrorModel.init("500", err.localizedDescription))
                }

                break
            case .failure(let error):
                print(error)
                completion(nil, ErrorModel.init("500", error.localizedDescription))
            }
        }
    }
    
    //MARK: - Update Book in Cart
    //API method to update Book in Cart
    func updateBookinCart(_ bookId: Int, _ count: Int, completion: @escaping(_ response: Cart?,_ error: ErrorModel?) -> Void )
    {
        let provider = MoyaProvider<BSServices>()
        provider.request(.updateBookinCart(bookId, count)) { result in
            
            switch result {
            case .success(let response):
                
                do {
                    let Obj = try JSONDecoder().decode(Cart.self, from: response.data)
                    completion(Obj, nil)
                }
                catch let err
                {
                    completion(nil, ErrorModel.init("500", err.localizedDescription))
                }

                break
            case .failure(let error):
                print(error)
                completion(nil, ErrorModel.init("500", error.localizedDescription))
            }
        }
    }
    
}
