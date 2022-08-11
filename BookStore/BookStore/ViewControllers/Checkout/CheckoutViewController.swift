//
//  CheckoutViewController.swift
//  BookStore
//
//  Created by Group D on 26/07/22.
//

import UIKit
import Kingfisher

class CheckoutViewController: UIViewController {

    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var taxesLabel: UILabel!
    @IBOutlet weak var booksCostLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updatePage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Checkout"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
    }
    
    @IBAction func checkoutButtonAction(_ sender: Any) {
        
        let obj = SuccessViewController.instantiate(appStoryboard: .checkout)
        obj.modalPresentationStyle = .overCurrentContext
        present(obj, animated: true, completion: nil)
    }
    
    func updatePage()
    {
        let booksCost = SharedSingleton.shared.cart?.books?.sum(\.price) ?? 0
        booksCostLabel.text = "$\(booksCost)"
        let taxes = booksCost*0.1
        taxesLabel.text = "$\(taxes)"
        let total = booksCost + taxes
        totalCostLabel.text = "$\(total)"
    }
    
    func updateCart()
    {
        var books: [Book] = []
        if let cartBooks = SharedSingleton.shared.cart?.books
        {
            books = cartBooks
        }
                
        var paramBooks: [[String: Any]] = []
        
        for obj in books
        {
            paramBooks.append(["bookId": obj.bookId ?? 0, "quantity": 1])
        }
        
        APIHelper.shared.updateCartDetails(["books": paramBooks]) { response, error in
            guard let resp = response, error == nil else {
                
                if let err = error
                {
                    SharedSingleton.shared.showErrorDialog(self, message: err.message)
                }
                return
            }
            
            SharedSingleton.shared.cart = resp
            self.updatePage()
        }
    }
}

extension CheckoutViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SharedSingleton.shared.cart?.books?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutCell") as? CheckoutCell {
            
            cell.selectionStyle = .none
            
            cell.plusButton.tag = indexPath.row
            cell.minusButton.tag = indexPath.row
            cell.deleteButton.tag = indexPath.row
            
            cell.plusButton.addTarget(self, action: #selector(increaseBookCountButtonAction(_:)), for: .touchUpInside)
            cell.minusButton.addTarget(self, action: #selector(decreaseBookCountButtonAction(_:)), for: .touchUpInside)
            cell.deleteButton.addTarget(self, action: #selector(deleteBookButtonAction(_:)), for: .touchUpInside)
            
            if let book = SharedSingleton.shared.cart?.books?[indexPath.row]
            {
                if let imgUrl = URL(string: book.coverImageUrl)
                {
                    cell.coverImageView.kf.setImage(with: imgUrl, placeholder: UIImage(named: "bookPlaceholder"))
                }
                cell.bookNameLabel.text = book.title
                cell.authorNameLabel.text = book.author
                cell.priceLabel.text = "$\(book.price ?? 0)"
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func increaseBookCountButtonAction(_ sender: UIButton)
    {
        var quantity: Int = SharedSingleton.shared.cart?.books?[sender.tag].quantity ?? 1
        quantity = quantity + 1
        SharedSingleton.shared.cart?.books?[sender.tag].quantity = quantity
        updateCart()
    }
    
    @objc func decreaseBookCountButtonAction(_ sender: UIButton)
    {
        var quantity: Int = SharedSingleton.shared.cart?.books?[sender.tag].quantity ?? 1
        
        if quantity == 1
        {
            SharedSingleton.shared.cart?.books?.remove(at: sender.tag)
        }
        else
        {
            quantity = quantity - 1
        }
        
        SharedSingleton.shared.cart?.books?[sender.tag].quantity = quantity
        updateCart()
    }
    
    @objc func deleteBookButtonAction(_ sender: UIButton)
    {
        SharedSingleton.shared.cart?.books?.remove(at: sender.tag)
        updateCart()
    }
}
