//
//  CheckoutViewController.swift
//  BookStore
//
//  Created by Group D on 26/07/22.
//

import UIKit
import Kingfisher
import JGProgressHUD

class CheckoutViewController: UIViewController {

    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var taxesLabel: UILabel!
    @IBOutlet weak var booksCostLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!

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
    
    func updateBooksInCart(_ id: Int, _ quantity: Int)
    {
        let hud = JGProgressHUD()
        hud.textLabel.text = ""
        hud.show(in: self.view)
        
        APIHelper.shared.updateBookinCart(id, quantity) { response, error in
            
            hud.dismiss()
            guard let resp = response, error == nil else {
                
                if let err = error
                {
                    SharedSingleton.shared.showErrorDialog(self, message: err.message)
                }
                return
            }
            
            SharedSingleton.shared.cart = resp
            self.tableView.reloadData()
            self.updatePage()
        }
    }
    
    func removeBookFromCart(_ id: Int)
    {
        let hud = JGProgressHUD()
        hud.textLabel.text = ""
        hud.show(in: self.view)
        
        APIHelper.shared.removeBookinCart(id) { response, error in
            
            hud.dismiss()
            guard let resp = response, error == nil else {
                
                if let err = error
                {
                    SharedSingleton.shared.showErrorDialog(self, message: err.message)
                }
                return
            }
            
            SharedSingleton.shared.cart = resp
            
            if SharedSingleton.shared.cart?.books?.count == 0
            {
                self.tableView.isHidden = true
                self.checkoutButton.isHidden = true
            }
            self.tableView.reloadData()
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
                if let imgUrl = URL(string: book.coverImageURL)
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
        if let book = SharedSingleton.shared.cart?.books?[sender.tag]
        {
            let quantity: Int = book.quantity + 1
            updateBooksInCart(book.bookId, quantity)
        }
    }
    
    @objc func decreaseBookCountButtonAction(_ sender: UIButton)
    {
        if let book = SharedSingleton.shared.cart?.books?[sender.tag]
        {
            let quantity: Int = book.quantity - 1
            
            if quantity == 0
            {
                removeBookFromCart(book.bookId)
            }
            else
            {
                updateBooksInCart(book.bookId, quantity)
            }
        }
    }
    
    @objc func deleteBookButtonAction(_ sender: UIButton)
    {
        if let book = SharedSingleton.shared.cart?.books?[sender.tag]
        {
            removeBookFromCart(book.bookId)
        }
    }
}
