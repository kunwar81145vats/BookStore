//
//  HomeViewController.swift
//  BookStore
//
//  Created by Group D on 18/07/22.
//

import UIKit
import Kingfisher
import JGProgressHUD

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var noBooksLabel: UILabel!

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
        checkoutButton.layer.cornerRadius = checkoutButton.frame.size.height/2
        
        setupLongGestureRecognizerOnCollection()
        getAllBooks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Home"
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        if UserDefaults.standard.value(forKey: UserDefaultKeys.authToken.rawValue) != nil
        {
            self.getCartDetails()
            
            if self.books.count != 0
            {
                self.updateFavBooks()
            }
        }
    }
    
    private func setupLongGestureRecognizerOnCollection() {
          let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
             lpgr.minimumPressDuration = 0.5
             lpgr.delaysTouchesBegan = true
          self.collectionView.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
         guard gestureReconizer.state != .began else { return }
         let point = gestureReconizer.location(in: self.collectionView)
         let indexPath = self.collectionView.indexPathForItem(at: point)
         if let index = indexPath{
               print(index.row)
             self.collectionView.reloadItems(at: [index])
             
             if books[index.row].isFav ?? false
             {
                 books[index.row].isFav = false
                 SharedSingleton.shared.deleteFromFavourite(id: books[index.row].bookId)
             }
             else
             {
                 books[index.row].isFav = true
                 SharedSingleton.shared.addToFavourite(book: books[index.row])
             }
             
             self.collectionView.reloadData()
         }
         else{
               print("Could not find index path")
         }
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
    
    func updateFavBooks()
    {
        let favBooks = SharedSingleton.shared.fetchFavourites()
        
        for (ind, obj) in books.enumerated()
        {
            if let favs = favBooks
            {
                if favs.contains(where: { book in
                    book.bookId == obj.bookId
                })
                {
                    books[ind].isFav = true
                }
                else
                {
                    books[ind].isFav = false
                }
            }
            else
            {
                books[ind].isFav = false
            }
        }
        
        self.collectionView.reloadData()
    }
    
    func getAllBooks()
    {
        let hud = JGProgressHUD()
        hud.textLabel.text = ""
        hud.show(in: self.view)
        APIHelper.shared.getBooks { [self] response, error in
            
            hud.dismiss()
            guard let resp = response, error == nil else {
                
                if let err = error
                {
                    SharedSingleton.shared.showErrorDialog(self, message: err.message)
                }
                return
            }
            
            self.books = resp
            if self.books.count == 0
            {
                self.collectionView.isHidden = true
                self.noBooksLabel.isHidden = false
            }
            else
            {
                self.collectionView.isHidden = false
                self.noBooksLabel.isHidden = true
            }
            
            self.updateFavBooks()
            self.collectionView.reloadData()
        }
    }
    
    func getCartDetails()
    {
        APIHelper.shared.getCartDetails() { response, error in
            guard let resp = response, error == nil else {
                
                if let err = error
                {
                    if err.status == "404"
                    {
                        SharedSingleton.shared.goToLoginDialog(self)
                    }
                    else
                    {
                        SharedSingleton.shared.showErrorDialog(self, message: err.message)
                    }
                }
                return
            }
            
            SharedSingleton.shared.cart = resp
            self.updateCheckoutButton()
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
            
            if self.searchResults.count == 0
            {
                self.collectionView.isHidden = true
                self.noBooksLabel.isHidden = false
            }
            else
            {
                self.collectionView.isHidden = false
                self.noBooksLabel.isHidden = true
            }
            
            self.collectionView.reloadData()
        }
    }
    
    func updateCheckoutButton()
    {
        if let books = SharedSingleton.shared.cart?.books, books.count != 0
        {
            checkoutButton.isHidden = false
        }
        else
        {
            checkoutButton.isHidden = true
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
        
        if let imgUrl = URL(string: book.coverImageURL)
        {
            cell.imageView.kf.setImage(with: imgUrl, placeholder: UIImage(named: "bookPlaceholder"))
        }
        cell.nameLabel.text = book.title
        cell.authorLabel.text = book.author
        cell.priceLabel.text = "$\(book.price ?? 0)"
        
        if book.isFav ?? false
        {
            cell.favImgView.image = UIImage(named: "filledHeart")
        }
        else
        {
            cell.favImgView.image = UIImage(named: "emptyHeart")
        }
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
        let obj = BookDetailsViewController.instantiate(appStoryboard: .home) as BookDetailsViewController
        
        let book = searchTextField.text?.count ?? 0 > 1 ? searchResults[indexPath.row] : books[indexPath.row]
        
        obj.book = book
        self.navigationController?.pushViewController(obj, animated: true)
    }
}
