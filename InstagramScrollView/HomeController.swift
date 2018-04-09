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
        
        //Anonymous Firebase Sign-In
        Auth.auth().signInAnonymously() { (user, error) in

        }
        
        //Firebase Live Observer
        let ref = Database.database().reference()
        ref.observe(.childAdded) { (snapshot) in

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
        
        
        let imageView = cell?.viewWithTag(1) as! UIImageView
        imageView.image = posts[indexPath.row].image
        
        let label = cell?.viewWithTag(2) as! UILabel
        label.text = posts[indexPath.row].description
        
        return cell!
    }
    
}








