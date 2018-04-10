//
//  ViewController.swift
//  InstagramScrollView
//
//  Created by Jason Park on 4/5/18.
//  Copyright © 2018 Jason Park. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: IBActions
    @IBAction func uploadImageButtonPressed(_ sender: Any) {
        perform(#selector(handleUploadImageButtonPressed))
    }
    
    var posts = [Post]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        let ref = Database.database().reference()
        //Anonymous Firebase Sign-In
        Auth.auth().signInAnonymously() { (user, error) in
            
        }
        
        //Firebase Live Observer
        ref.child("posts").observe(.childAdded) { (snapshot) in
            self.loadCellData()
        }
        
        
        
    }
    
    fileprivate func loadCellData() {
        let ref = Database.database().reference()
        ref.child("posts").queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value) { (snapshot) in
            
            if let postsDictionary = snapshot.value as? [String : AnyObject] {
                for post in postsDictionary {
                    
                    if let postDictionary = post.value as? [String : AnyObject] {
                        let post = Post()
                        post.description = postDictionary["description"] as? String
                        post.timestamp = postDictionary["timestamp"] as? String
                        post.downloadUrl = postDictionary["downloadUrl"] as? String
                        
                        guard let url = URL(string: post.downloadUrl!) else { return }
                        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                            if error != nil {
                                print(error)
                                return
                            }
                           
                            DispatchQueue.main.async {
                                post.image = UIImage(data: data!)
                            }
                        }) .resume()
 
                        self.posts.insert(post, at: 0)
                        //self.posts.append(post)
                    }
                    self.tableView.reloadData()
                }
                
            }

        }
    }


}

extension HomeController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        
        let imageView = cell?.viewWithTag(1) as? UIImageView
        imageView?.image = posts[indexPath.row].image
        
        let label = cell?.viewWithTag(2) as? UILabel
        label?.text = posts[indexPath.row].description
        
        let ref = Database.database().reference()

        
        return cell!
    }
    
}








