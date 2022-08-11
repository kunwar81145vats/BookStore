//
//  BookDetailsViewController.swift
//  BookStore
//
//  Created by Group D on 21/07/22.
//

import UIKit
import Kingfisher
import FirebaseAnalytics

class BookDetailsViewController: UIViewController {

    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var addToCartButton: UIButton!

    var book: Book!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addToCartButton.layer.borderColor = addToCartButton.tintColor.cgColor
        addToCartButton.layer.borderWidth = 1.0
        addToCartButton.layer.cornerRadius = 5
        
        showBookDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func showBookDetails()
    {
        if let imgUrl = URL(string: book.coverImageURL)
        {
            bookImageView.kf.setImage(with: imgUrl, placeholder: UIImage(named: "bookPlaceholder"))
        }
        bookNameLabel.text = book.title
        authorNameLabel.text = book.author
        summaryTextView.text = book.summary
        
        if let cartBook = SharedSingleton.shared.cart?.books?.first(where: { obj in
            obj.bookId == book.bookId
        })
        {
            addToCartButton.setTitle("(\(cartBook.quantity ?? 1)) Add more to Cart ($\(book.price ?? 0))", for: .normal)
        }
        else
        {
            addToCartButton.setTitle("Add to Cart ($\(book.price ?? 0))", for: .normal)
        }
    }
    
    @IBAction func favouriteButtonAction(_ sender: Any) {
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToCartButtonAction(_ sender: Any) {
        
        if UserDefaults.standard.value(forKey: UserDefaultKeys.authToken.rawValue) != nil
        {
            self.updateCart()
            
            Analytics.logEvent("add_to_cart", parameters: nil)
        }
        else
        {
            SharedSingleton.shared.showLoginDialog(self, message: "Please login to add books to the cart.")
        }
    }
    
    @IBAction func locationsButtonAction(_ sender: Any) {
        
        let obj = LocationsViewController.instantiate(appStoryboard: .home) as LocationsViewController
        obj.book = book
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func updateCart()
    {
        if let cartBook = SharedSingleton.shared.cart?.books?.first(where: { obj in
            obj.bookId == book.bookId
        })
        {
            APIHelper.shared.updateBookinCart(cartBook.bookId, cartBook.quantity + 1) { response, error in
                
                guard let resp = response, error == nil else {
                    
                    if let err = error
                    {
                        SharedSingleton.shared.showErrorDialog(self, message: err.message)
                    }
                    return
                }
                
                SharedSingleton.shared.cart = resp
                self.showBookDetails()
            }
        }
        else
        {
            APIHelper.shared.insertBookinCart(book.bookId) { response, error in
                
                guard let resp = response, error == nil else {
                    
                    if let err = error
                    {
                        SharedSingleton.shared.showErrorDialog(self, message: err.message)
                    }
                    return
                }
                
                SharedSingleton.shared.cart = resp
                self.showBookDetails()
            }
        }
    }
}
