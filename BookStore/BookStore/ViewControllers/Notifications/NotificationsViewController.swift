//
//  NotificationsViewController.swift
//  BookStore
//
//  Created by Group D on 18/07/22.
//

import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak var noBooksLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Notifications"
        self.navigationController?.isNavigationBarHidden = false
        
//        if books.count == 0
//        {
            tableView.isHidden = true
            noBooksLabel.isHidden = false
//        }
//        else
//        {
//            collectionView.isHidden = false
//            noBooksLabel.isHidden = true
//        }
    }
    
}


extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as? NotificationCell {
            
            cell.datelabel.text = "5 Nov, 2022"
            cell.titleLabel.text = "Notification name"
            cell.detailLabel.text = "Lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum"
            
            return cell
        }
        
        return UITableViewCell()
    }
    
}
