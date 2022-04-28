//
//  FeedViewController.swift
//  PhotoSharingWithParse
//
//  Created by Merve Nurgül BAĞCI on 20.04.2022.
//

import UIKit
import Parse
class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var postArray = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newPost"), object: nil)
    }
    
    @objc func getData(){
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground{(objects, error) in
            if error != nil{
                self.errorMessage(title: "Error", message: error?.localizedDescription ?? "Hata")
            }else{
                if objects != nil{
                    if objects!.count > 0{
                        self.postArray.removeAll(keepingCapacity: false)
                        for object in objects!{
                            if let userName = object.object(forKey: "postowner") as? String{
                                if let userComment = object.object(forKey: "postcomment") as? String{
                                    if let userImage = object.object(forKey: "postimage") as? PFFileObject{
                                        let post = Post(userName: userName, userComment: userComment, userImage: userImage)
                                        self.postArray.append(post)
                                    }
                                }
                                    
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
    }
    
    func errorMessage(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        cell.usernameLabel.text = postArray[indexPath.row].userName
        cell.commentLabel.text = postArray[indexPath.row].userComment
        postArray[indexPath.row].userImage.getDataInBackground{ (data, error) in
            if error == nil {
                if let data = data {
                    cell.postImageView.image = UIImage(data: data)
                }
            }
            
        }
        return cell
    }

}
