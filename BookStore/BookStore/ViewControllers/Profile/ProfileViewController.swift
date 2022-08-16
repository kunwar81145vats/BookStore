//
//  ProfileViewController.swift
//  BookStore
//
//  Created by Group D on 18/07/22.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var textArr: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        
        if UserDefaults.standard.value(forKey: UserDefaultKeys.authToken.rawValue) == nil
        {
            SharedSingleton.shared.showLoginDialog(self, message: "Please login to the app to view this feature.")
        }
        else
        {
            textArr = ["Profile", "Address", "Orders", "Logout"]
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Profile"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as? ProfileCell {
            
            cell.nameLabel.text = textArr[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            self.tabBarController?.tabBar.isHidden = true
            let obj = UpdateProfileViewController.instantiate(appStoryboard: .profile)
            self.navigationController?.pushViewController(obj, animated: true)
        case 1:
            self.tabBarController?.tabBar.isHidden = true
            let obj = AddressViewController.instantiate(appStoryboard: .profile)
            self.navigationController?.pushViewController(obj, animated: true)
        case 2:
            self.tabBarController?.tabBar.isHidden = true
            let obj = OrdersViewController.instantiate(appStoryboard: .profile)
            self.navigationController?.pushViewController(obj, animated: true)
        case 3:
            SharedSingleton.shared.deleteAuthToken()
            if let signInObj = self.navigationController?.viewControllers.first(where: { vc in
                vc.isKind(of: SignInViewController.self)
            })
            {
                self.view.window?.rootViewController = UINavigationController(rootViewController: signInObj)
            }
            else
            {
                let obj = SignInViewController.instantiate(appStoryboard: .login)
                self.view.window?.rootViewController = UINavigationController(rootViewController: obj)
            }
        default:
            break
        }
    }
}
