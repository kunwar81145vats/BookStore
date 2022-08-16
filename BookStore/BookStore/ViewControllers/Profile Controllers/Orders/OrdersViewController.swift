//
//  OrdersViewController.swift
//  BookStore
//
//  Created by Group D on 26/07/22.
//

import UIKit
import JGProgressHUD

class OrdersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var orders: [Order]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Orders"
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func fetchOrders()
    {
        let hud = JGProgressHUD()
        hud.textLabel.text = ""
        hud.show(in: self.view)
        
        APIHelper.shared.getOrders { response, error in
            hud.dismiss()
            
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
            
            self.orders = resp
            self.tableView.reloadData()
        }
    }
}

extension OrdersViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as? OrderCell {
            
            cell.selectionStyle = .none
            
            if let order = orders?[indexPath.row]
            {
                cell.costLabel.text = "$\(order.totalPrice ?? 0)"
                cell.orderIdLabel.text = "Order #\(order.orderId ?? 0)"
                cell.quantityLabel.text = "\(order.listBooks.count)"
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale.current
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                if let date = dateFormatter.date(from:order.date)
                {
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    cell.dateLabel.text = dateFormatter.string(from: date)
                }
                else
                {
                    cell.dateLabel.text = order.date
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}
