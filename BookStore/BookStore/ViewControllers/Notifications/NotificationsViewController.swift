//
//  NotificationsViewController.swift
//  BookStore
//
//  Created by Group D on 18/07/22.
//

import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Notifications"
        self.navigationController?.isNavigationBarHidden = false
    }
    
}


extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
