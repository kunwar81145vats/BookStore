//
//  OrdersViewController.swift
//  BookStore
//
//  Created by Group D on 26/07/22.
//

import UIKit

class OrdersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Orders"
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension OrdersViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as? OrderCell {
            
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
}
