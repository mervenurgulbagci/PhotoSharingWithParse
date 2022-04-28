//
//  ViewController.swift
//  PhotoSharingWithParse
//
//  Created by Merve Nurgül BAĞCI on 19.04.2022.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func loginClicked(_ sender: Any) {
        if usernameText.text != "" && passwordText.text != "" {
            
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!){
                (user ,error) in
                if error != nil{
                    self.showErrorMessage(title: "Error!", message: error?.localizedDescription ?? "Error" )
                }else{
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
        }else{
            showErrorMessage(title: "Error!", message: "Please, enter email or password")
        }
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != "" {
            let user = PFUser()
            user.username = usernameText.text!
            user.password = passwordText.text!
            user.signUpInBackground{ (success , error) in
                if error != nil{
                    self.showErrorMessage(title: "Error!", message: error?.localizedDescription ?? "Error" )
                }else{
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
                
            }
            
        }
        else{
            showErrorMessage(title: "Error!", message: "Please, enter email or password")
        }
    }
    
    func showErrorMessage(title : String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

