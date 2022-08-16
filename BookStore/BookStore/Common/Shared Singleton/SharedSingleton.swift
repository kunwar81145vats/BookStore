//
//  SharedSingleton.swift
//  BookStore
//
//  Created by Group D on 19/07/22.
//

import UIKit
import CoreData

class SharedSingleton: NSObject {

    static let shared: SharedSingleton = SharedSingleton()
    
    var user: User?
    var cart: Cart?
    
    private override init() {}
    
    func showErrorDialog(_ vc: UIViewController, message: String? = "Something went wrong")
    {
        let dialogMessage = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        dialogMessage.addAction(UIAlertAction.init(title: "OK", style: .default))
        vc.present(dialogMessage, animated: true, completion: nil)
    }
    
    func goToLoginDialog(_ vc: UIViewController, message: String? = "Your login has expired")
    {
        let dialogMessage = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        dialogMessage.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { action in
            
            if let signInObj = vc.navigationController?.viewControllers.first(where: { vc in
                vc.isKind(of: SignInViewController.self)
            })
            {
                vc.view.window?.rootViewController = UINavigationController(rootViewController: signInObj)
            }
            else
            {
                let obj = SignInViewController.instantiate(appStoryboard: .login)
                vc.view.window?.rootViewController = UINavigationController(rootViewController: obj)
            }
        }))
        dialogMessage.addAction(UIAlertAction.init(title: "Cancel", style: .cancel))
        vc.present(dialogMessage, animated: true, completion: nil)
    }
    
    func showLoginDialog(_ vc: UIViewController, message: String? = "Please login")
    {
        let dialogMessage = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        dialogMessage.addAction(UIAlertAction.init(title: "Go to Login", style: .default, handler: { action in
            
            if let signInObj = vc.navigationController?.viewControllers.first(where: { vc in
                vc.isKind(of: SignInViewController.self)
            })
            {
                vc.view.window?.rootViewController = UINavigationController(rootViewController: signInObj)
            }
            else
            {
                let obj = SignInViewController.instantiate(appStoryboard: .login)
                vc.view.window?.rootViewController = UINavigationController(rootViewController: obj)
            }
        }))
        dialogMessage.addAction(UIAlertAction.init(title: "Cancel", style: .cancel))
        vc.present(dialogMessage, animated: true, completion: nil)
    }
    
    func getAuthToken() -> String
    {
        return UserDefaults.standard.string(forKey: UserDefaultKeys.authToken.rawValue) ?? ""
    }
    
    func saveAuthToken(_ token: String)
    {
        UserDefaults.standard.set(token, forKey: UserDefaultKeys.authToken.rawValue)
    }
    
    func deleteAuthToken()
    {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.authToken.rawValue)
    }
    
    //Save book to favourites (Core Data)
    func addToFavourite(book: Book)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Favourites", in: managedContext)!
        
        let favouriteBook = Favourites(entity: entity, insertInto: managedContext)
        
        favouriteBook.bookId = Int16(book.bookId)
        favouriteBook.coordinateY = book.coordinateY
        favouriteBook.coordinateX = book.coordinateX
        favouriteBook.quantity = Int16(book.quantity)
        favouriteBook.coverImageURL = book.coverImageURL
        favouriteBook.title = book.title
        favouriteBook.author = book.author
        favouriteBook.category = book.category
        favouriteBook.price = book.price
        favouriteBook.summary = book.summary
                
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //Delete book from favourites (Core Data)
    func deleteFromFavourite(id: Int)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
          
        let fetchRequest = NSFetchRequest<Favourites>(entityName: "Favourites")
        let predicate = NSPredicate(format: "bookId = %d", Int16(id))
        fetchRequest.predicate = predicate
        
        do {
            let books = try managedContext.fetch(fetchRequest)
            if let book = books.first
            {
                managedContext.delete(book)
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
    }
    
    //Fetch favourites books (Core Data)
    func fetchFavourites() -> [Book]?
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
          
        let fetchRequest = NSFetchRequest<Favourites>(entityName: "Favourites")
        
        do {
            let favourites = try managedContext.fetch(fetchRequest)
            
            var books: [Book] = []
            
            for obj in favourites
            {
                var bookObj: Book = Book()
                
                bookObj.bookId = Int(obj.bookId)
                bookObj.coordinateY = obj.coordinateY
                bookObj.coordinateX = obj.coordinateX
                bookObj.quantity = Int(obj.quantity)
                bookObj.coverImageURL = obj.coverImageURL
                bookObj.title = obj.title
                bookObj.author = obj.author
                bookObj.category = obj.category
                bookObj.price = obj.price
                bookObj.summary = obj.summary
                
                books.append(bookObj)
            }
            
            return books
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
}
