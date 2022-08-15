//
//  FavouritesViewController.swift
//  BookStore
//
//  Created by Group D on 18/07/22.
//

import UIKit
import Kingfisher

class FavouritesViewController: UIViewController {

    @IBOutlet weak var noBooksLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var checkoutButton: UIButton!

    var books: [Book] = []
    
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
        
        checkoutButton.layer.cornerRadius = checkoutButton.frame.size.height/2
        setupLongGestureRecognizerOnCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Favourites"
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        if UserDefaults.standard.value(forKey: UserDefaultKeys.authToken.rawValue) != nil
        {
            self.getCartDetails()
        }
        
        books = SharedSingleton.shared.fetchFavourites() ?? []
        
        if books.count == 0
        {
            collectionView.isHidden = true
            noBooksLabel.isHidden = false
        }
        else
        {
            collectionView.isHidden = false
            noBooksLabel.isHidden = true
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
             
             SharedSingleton.shared.deleteFromFavourite(id: books[index.row].bookId)
             books.remove(at: index.row)
             self.collectionView.reloadItems(at: [index])
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
    
    func getCartDetails()
    {
        APIHelper.shared.getCartDetails() { response, error in
            guard let resp = response, error == nil else {
                
                if let err = error
                {
                    SharedSingleton.shared.showErrorDialog(self, message: err.message)
                }
                return
            }
            
            SharedSingleton.shared.cart = resp
            self.updateCheckoutButton()
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

extension FavouritesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath as IndexPath) as! BookCell
        
        let book = books[indexPath.row]
        
        if let imgUrl = URL(string: book.coverImageURL)
        {
            cell.imageView.kf.setImage(with: imgUrl, placeholder: UIImage(named: "bookPlaceholder"))
        }
        cell.nameLabel.text = book.title
        cell.authorLabel.text = book.author
        cell.priceLabel.text = "$\(book.price ?? 0)"
        cell.favImgView.image = UIImage(named: "filledHeart")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfSections section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.tabBarController?.tabBar.isHidden = true
        let obj = BookDetailsViewController.instantiate(appStoryboard: .home) as BookDetailsViewController
        obj.book = books[indexPath.row]
        self.navigationController?.pushViewController(obj, animated: true)

    }
}
