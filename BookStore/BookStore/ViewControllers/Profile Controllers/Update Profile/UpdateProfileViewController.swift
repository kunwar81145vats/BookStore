//
//  UpdateProfileViewController.swift
//  BookStore
//
//  Created by Group D on 26/07/22.
//

import UIKit

class UpdateProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let textArr: [String] = ["Name", "Email address", "Phone number"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "UpdateDetailCell", bundle: nil), forCellReuseIdentifier: "UpdateDetailCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Profile"
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension UpdateProfileViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateDetailCell") as? UpdateDetailCell {
            
            cell.nameLabel.text = textArr[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
}
