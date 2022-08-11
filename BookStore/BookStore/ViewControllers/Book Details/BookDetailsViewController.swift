//
//  BookDetailsViewController.swift
//  BookStore
//
//  Created by Group D on 21/07/22.
//

import UIKit
import Kingfisher

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
        if let imgUrl = URL(string: book.coverImageUrl)
        {
            bookImageView.kf.setImage(with: imgUrl, placeholder: UIImage(named: "bookPlaceholder"))
        }
        bookNameLabel.text = book.title
        authorNameLabel.text = book.author
        summaryTextView.text = book.summary
        addToCartButton.setTitle("Add to Cart ($\(book.price ?? 0)", for: .normal)
    }
    
    @IBAction func favouriteButtonAction(_ sender: Any) {
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToCartButtonAction(_ sender: Any) {
        
        updateCart()
    }
    
    @IBAction func locationsButtonAction(_ sender: Any) {
        
        let obj = LocationsViewController.instantiate(appStoryboard: .home)
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func updateCart()
    {
        var books: [Book] = []
        if let cartBooks = SharedSingleton.shared.cart?.books
        {
            books = cartBooks
        }
        
        var cartBook: Book = book
        cartBook.quantity = 1
        
        books.append(cartBook)
        
        var paramBooks: [[String: Any]] = []
        
        for obj in books
        {
            paramBooks.append(["bookId": obj.bookId ?? 0, "quantity": 1])
        }
        
        APIHelper.shared.updateCartDetails(["books": paramBooks]) { _, error in
            guard error == nil else {
                
                if let err = error
                {
                    SharedSingleton.shared.showErrorDialog(self, message: err.message)
                }
                return
            }
        }
    }
}
