//
//  BookDetailsViewController.swift
//  BookStore
//
//  Created by Group D on 21/07/22.
//

import UIKit
import Kingfisher
import FirebaseAnalytics
import JGProgressHUD

class BookDetailsViewController: UIViewController {

    @IBOutlet weak var checkoutButtonWidthConstriant: NSLayoutConstraint!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var checkoutButton: UIButton!

    var book: Book!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addToCartButton.layer.borderColor = addToCartButton.tintColor.cgColor
        addToCartButton.layer.borderWidth = 1.0
        addToCartButton.layer.cornerRadius = 5
        checkoutButton.layer.cornerRadius = checkoutButton.frame.size.height/2
        
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
        
        if SharedSingleton.shared.cart?.books?.count == 0
        {
            checkoutButton.isHidden = true
            checkoutButtonWidthConstriant.constant = 0
        }
        else if SharedSingleton.shared.cart == nil
        {
            checkoutButton.isHidden = true
            checkoutButtonWidthConstriant.constant = 0
        }
        else
        {
            checkoutButton.isHidden = false
            checkoutButtonWidthConstriant.constant = 70
        }
        
        if book.isFav ?? false
        {
            favouriteButton.setImage(UIImage(named: "filledHeart"), for: .normal)
        }
        else
        {
            favouriteButton.setImage(UIImage(named: "emptyHeart"), for: .normal)
        }
        
    }
    
    @IBAction func favouriteButtonAction(_ sender: Any) {
        
        if book.isFav ?? false
        {
            book.isFav = true
            SharedSingleton.shared.addToFavourite(book: book)
        }
        else
        {
            book.isFav = true
            SharedSingleton.shared.deleteFromFavourite(id: book.bookId)
        }
        
        showBookDetails()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkoutButtonAction(_ sender: Any) {
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
        let hud = JGProgressHUD()
        hud.textLabel.text = ""
        hud.show(in: self.view)
        
        if let cartBook = SharedSingleton.shared.cart?.books?.first(where: { obj in
            obj.bookId == book.bookId
        })
        {
            APIHelper.shared.updateBookinCart(cartBook.bookId, cartBook.quantity + 1) { response, error in
                
                hud.dismiss()
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
                
                hud.dismiss()
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
