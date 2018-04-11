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
    
    var ref: DatabaseReference?
    var refHandle: UInt!
    var posts = [Post]()
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: IBActions
    @IBAction func uploadImageButtonPressed(_ sender: Any) {
        perform(#selector(handleUploadImageButtonPressed))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegates
        tableView.delegate = self
        tableView.dataSource = self

        if let uid = Auth.auth().currentUser?.uid {
            ref = Database.database().reference()
        }
        
        fetchDataAndRefreshCells()

    }

    func fetchDataAndRefreshCells() {
        refHandle = ref?.child("posts").observe(.childAdded, with: { (snapshot) in
            if let postsDictionary = snapshot.value as? [String : AnyObject] {
                let post = Post()
                
                post.description = postsDictionary["description"] as? String
                post.timestamp = postsDictionary["timestamp"] as? String
                post.downloadUrl = postsDictionary["downloadUrl"] as? String
                
                guard let url = URL(string: post.downloadUrl!) else { return }
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        post.image = UIImage(data: data!)
                        self.posts.insert(post, at: 0)
                        self.tableView.reloadData()
                    }
                    
                }).resume()
                
//                self.posts.append(post)
//
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
            }
            
        })
    }
    
//    fileprivate func loadCellData() {
//        let ref = Database.database().reference()
//        ref.child("posts").queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value) { (snapshot) in
//
//            if let postsDictionary = snapshot.value as? [String : AnyObject] {
//                print(postsDictionary)
////                for post in postsDictionary {
////                    print(post)
////                    if let postDictionary = post.value as? [String : AnyObject] {
////                        let post = Post()
////                        post.description = postDictionary["description"] as? String
////                        post.timestamp = postDictionary["timestamp"] as? String
////                        post.downloadUrl = postDictionary["downloadUrl"] as? String
//
////                        guard let url = URL(string: post.downloadUrl!) else { return }
////                        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
////                            if error != nil {
////                                print(error)
////                                return
////                            }
////
////                            DispatchQueue.main.async {
////                                post.image = UIImage(data: data!)
////                                self.posts.insert(post, at: 0)
////                                self.tableView.reloadData()
////                            }
////
////                        }).resume()
//
//                   //}
//
//                //}
//                //self.tableView.reloadData()
//            }
//
//        }
//    }


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








