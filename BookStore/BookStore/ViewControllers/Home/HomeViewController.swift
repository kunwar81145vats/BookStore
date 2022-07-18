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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "BookCell", bundle: .main), forCellWithReuseIdentifier: "BookCell")
        
        let cellWidth = collectionView.frame.size.width/3 - 30

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth + 100)
        
        collectionView.collectionViewLayout = layout
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Home"
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath as IndexPath) as! BookCell
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfSections section: Int) -> Int {
        return 1
    }
}
