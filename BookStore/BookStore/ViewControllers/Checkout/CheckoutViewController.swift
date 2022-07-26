//
//  CheckoutViewController.swift
//  BookStore
//
//  Created by Group D on 26/07/22.
//

import UIKit

class CheckoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
}

extension CheckoutViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutCell") as? CheckoutCell {
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        return UITableViewCell()
    }
}
