//
//  HomeViewController.swift
//  BookStore
//
//  Created by Group D on 18/07/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var checkoutButton: UIButton!

    @IBOutlet weak var cancelSearchBtnWidthConstraint: NSLayoutConstraint!
    private let cancelBtnWidth = 90
    
    var books: [Book] = []
    var searchResults: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "BookCell", bundle: .main), forCellWithReuseIdentifier: "BookCell")
        
        let cellWidth = collectionView.frame.size.width/3 - 30

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth + 100)
        
        collectionView.collectionViewLayout = layout
        checkoutButton.layer.cornerRadius = checkoutButton.frame.size.width/2
        checkoutButton.isHidden = true
        cancelSearchBtnWidthConstraint.constant = 0
        searchTextField.delegate = self
        
        getAllBooks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Home"
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func checkoutButtonAction(_ sender: Any) {
        
        self.tabBarController?.tabBar.isHidden = true
        let obj = CheckoutViewController.instantiate(appStoryboard: .checkout)
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        searchTextField.becomeFirstResponder()
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        searchTextField.resignFirstResponder()
        searchTextField.text = ""
        searchResults = []
        collectionView.reloadData()
        cancelSearchBtnWidthConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func getAllBooks()
    {
        APIHelper.shared.getBooks { response, error in
            guard let resp = response, error == nil else {
                
                if let err = error
                {
                    SharedSingleton.shared.showErrorDialog(self, message: err.message)
                }
                return
            }
            
            self.books = resp
            self.collectionView.reloadData()
        }
    }
    
    func searchBooks(_ search: String)
    {
        APIHelper.shared.searchBooks(search) { response, error in
            guard let resp = response, error == nil else {
                
                if let err = error
                {
                    SharedSingleton.shared.showErrorDialog(self, message: err.message)
                }
                return
            }
            
            self.searchResults = resp
            self.collectionView.reloadData()
        }
    }
}

extension HomeViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelSearchBtnWidthConstraint.constant = 90
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newText = (searchTextField.text ?? "") + string
        
        if newText.count > 1
        {
            searchBooks(newText)
        }
        else
        {
            searchResults = []
        }
        return true
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath as IndexPath) as! BookCell
        
        let book = searchTextField.text?.count ?? 0 > 1 ? searchResults[indexPath.row] : books[indexPath.row]
        
        cell.nameLabel.text = book.title
        cell.authorLabel.text = book.author
        cell.priceLabel.text = "$\(book.price ?? 0)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return searchTextField.text?.count ?? 0 > 1 ? searchResults.count : books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfSections section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.tabBarController?.tabBar.isHidden = true
        let obj = BookDetailsViewController.instantiate(appStoryboard: .home)
        self.navigationController?.pushViewController(obj, animated: true)
    }
}
