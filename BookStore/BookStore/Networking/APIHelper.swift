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
    
    func saveUserDetails(user: User)
    {
        UserDefaults.standard.set(user.fullName, forKey: UserDefaultKeys.name.rawValue)
        UserDefaults.standard.set(user.email, forKey: UserDefaultKeys.email.rawValue)
        UserDefaults.standard.set(user.phoneNumber, forKey: UserDefaultKeys.phone.rawValue)
        UserDefaults.standard.set(user.address, forKey: UserDefaultKeys.address.rawValue)
        UserDefaults.standard.set(user.city, forKey: UserDefaultKeys.city.rawValue)
        UserDefaults.standard.set(user.state, forKey: UserDefaultKeys.state.rawValue)
        UserDefaults.standard.set(user.postalCode, forKey: UserDefaultKeys.postal.rawValue)

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
                    self.saveUserDetails(user: userObj)
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
                    self.saveUserDetails(user: userObj)
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
    
    //MARK: - Update Profile APi
    //API method to update user Profile
    func updateProfile(_ param: [String: String], completion: @escaping(_ response: User?,_ error: ErrorModel?) -> Void )
    {
        let provider = MoyaProvider<BSServices>()
        provider.request(.updateProfile(param)) { result in
            
            switch result {
            case .success(let response):
                
                let object = try? JSONSerialization.jsonObject(
                    with: response.data,
                    options: []
                )
                
                let resp = response.response
                if resp?.statusCode == 404
                {
                    SharedSingleton.shared.deleteAuthToken()
                    completion(nil, ErrorModel("404", "Token expired"))
                }
                
                do {
                    let userObj = try JSONDecoder().decode(User.self, from: response.data)
                    self.saveUserDetails(user: userObj)
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

                    completion(userObj, nil)
                }
                catch let err
                {
                    completion(nil, ErrorModel("500", err.localizedDescription))
                }

                break
            case .failure(let error):
                print(error)
                completion(nil, ErrorModel("500", error.localizedDescription))
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

                let resp = response.response
                if resp?.statusCode == 404
                {
                    SharedSingleton.shared.deleteAuthToken()
                    completion(nil, ErrorModel("404", "Token expired"))
                }
                
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
                
                let resp = response.response
                if resp?.statusCode == 404
                {
                    SharedSingleton.shared.deleteAuthToken()
                    completion(nil, ErrorModel("404", "Token expired"))
                }
                
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
                
                let resp = response.response
                if resp?.statusCode == 404
                {
                    SharedSingleton.shared.deleteAuthToken()
                    completion(nil, ErrorModel("404", "Token expired"))
                }
                
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
                
                let resp = response.response
                if resp?.statusCode == 404
                {
                    SharedSingleton.shared.deleteAuthToken()
                    completion(nil, ErrorModel("404", "Token expired"))
                }
                
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
    
    //MARK: - Place New Order
    //API method to create new order
    func placeNewOrder(_ param: [String: Any], completion: @escaping(_ response: Order?,_ error: ErrorModel?) -> Void )
    {
        let provider = MoyaProvider<BSServices>()
        provider.request(.placeOrder(param)) { result in
            
            switch result {
            case .success(let response):
                
                let resp = response.response
                if resp?.statusCode == 404
                {
                    SharedSingleton.shared.deleteAuthToken()
                    completion(nil, ErrorModel("404", "Token expired"))
                }
                
                do {
                    let Obj = try JSONDecoder().decode(Order.self, from: response.data)
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
    
    //MARK: - Get Order
    //API method to create new order
    func getOrders(completion: @escaping(_ response: [Order]?,_ error: ErrorModel?) -> Void )
    {
        let provider = MoyaProvider<BSServices>()
        provider.request(.getOrders) { result in
            
            switch result {
            case .success(let response):
                
                let resp = response.response
                if resp?.statusCode == 404
                {
                    SharedSingleton.shared.deleteAuthToken()
                    completion(nil, ErrorModel("404", "Token expired"))
                }
                
                do {
                    let Obj = try JSONDecoder().decode([Order].self, from: response.data)
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
