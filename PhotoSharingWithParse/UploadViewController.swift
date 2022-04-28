//
//  UploadViewController.swift
//  PhotoSharingWithParse
//
//  Created by Merve Nurgül BAĞCI on 20.04.2022.
//

import UIKit
import Parse
class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentText: UITextField!
    
    @IBOutlet weak var shareButton : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let keyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        view.addGestureRecognizer(keyboardRecognizer)
        
        imageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        view.addGestureRecognizer(gestureRecognizer)
        shareButton.isEnabled = false
    }

    @objc func selectImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    @IBAction func shareButtonClicked(_ sender: Any){
        shareButton.isEnabled = false
        let post = PFObject(className: "Post")
        
        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        
        if let data = data{
            if PFUser.current() != nil{
                let parseImage = PFFileObject(name: "image.jpg", data: data)
                post["postimage"] = parseImage
                post["postcomment"] = commentText.text!
                post["postowner"] = PFUser.current()!.username!
                
                post.saveInBackground { (success, error) in
                    if error != nil{
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "Error", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        self.commentText.text = ""
                        self.imageView.image = UIImage(named: "select")
                        self.tabBarController?.selectedIndex = 0
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newpost"), object: nil)
                    }
                }
            }
        }
        
    }

}
