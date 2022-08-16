//
//  UpdateProfileViewController.swift
//  BookStore
//
//  Created by Group D on 26/07/22.
//

import UIKit
import JGProgressHUD

class UpdateProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let textArr: [String] = ["Name", "Email address", "Phone number"]
    var inputsArr: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "UpdateDetailCell", bundle: nil), forCellReuseIdentifier: "UpdateDetailCell")
        
        inputsArr.append(UserDefaults.standard.value(forKey: UserDefaultKeys.name.rawValue) as? String ?? "")
        inputsArr.append(UserDefaults.standard.value(forKey: UserDefaultKeys.email.rawValue) as? String ?? "")
        inputsArr.append(UserDefaults.standard.value(forKey: UserDefaultKeys.phone.rawValue) as? String ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Profile"
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        let name = inputsArr[0]
        let email = inputsArr[1]
        let phone = inputsArr[2]
        
        if !email.isValidEmail()
        {
            SharedSingleton.shared.showErrorDialog(self, message: "Please enter a valid email address")
            return
        }
        let param: [String: String] = ["fullName": name, "email": email, "phoneNumber": phone]
        
        let hud = JGProgressHUD()
        hud.textLabel.text = ""
        hud.show(in: self.view)
        
        APIHelper.shared.updateProfile(param) { response, error in
            
            hud.dismiss()
            guard response != nil, error == nil else
            {
                if let err = error
                {
                    SharedSingleton.shared.showErrorDialog(self, message: err.message)
                }
                return
            }
            
            SharedSingleton.shared.showSuccessDialog(self, message: "Profile updated successfully")
        }
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
            cell.inputTextField.text = inputsArr[indexPath.row]
            
            cell.inputTextField.tag = indexPath.row
            cell.inputTextField.delegate = self
            
            return cell
        }
        
        return UITableViewCell()
    }
    
}

extension UpdateProfileViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool // return NO to not change text
    {
        let finalText = (textField.text ?? "") + string
        inputsArr.insert(finalText, at: textField.tag)
        
        return true
    }
}
