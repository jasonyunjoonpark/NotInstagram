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
    var activityIndicator = UIActivityIndicatorView()
    
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
        
        //Refresh cells live
        fetchDataAndRefreshCells()

    }

    fileprivate func fetchDataAndRefreshCells() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        refHandle = ref?.child("posts").observe(.childAdded, with: { (snapshot) in
    
            //Cast Firebase data as dictionary
            if let postsDictionary = snapshot.value as? [String : AnyObject] {
                
                //Start activity indicator animation
                self.activityIndicator.startAnimating()
                
                //Init post object
                let post = Post()
                post.description = postsDictionary["description"] as? String
                post.timestamp = postsDictionary["timestamp"] as? Double
                post.downloadUrl = postsDictionary["downloadUrl"] as? String
                
                //Fetch post image
                guard let url = URL(string: post.downloadUrl!) else { return }
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        //Add image to post instance
                        post.image = UIImage(data: data!)
                        
                        //Add post instance to posts array
                        self.posts.insert(post, at: 0)
                        
                        //Sort posts array by timestamp
                        self.posts.sort{ $0.timestamp! > $1.timestamp! }
                        
                        //Reload cells
                        self.tableView.reloadData()
                        
                        //End activity indicator animation
                        self.activityIndicator.stopAnimating()
                        
                    }
                }).resume()
            }
        })
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








