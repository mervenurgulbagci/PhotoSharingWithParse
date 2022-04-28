//
//  SettingsViewController.swift
//  PhotoSharingWithParse
//
//  Created by Merve Nurgül BAĞCI on 21.04.2022.
//

import UIKit
import Parse
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func logoutClicked(_ sender: Any) {
        PFUser.logOutInBackground{ (error) in
            if error != nil{
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "Error", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
        }
            else{
                self.performSegue(withIdentifier: "toViewController", sender: nil)
            }
        
    }
    

}
}
