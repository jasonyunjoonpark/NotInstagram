//
//  DescriptionController.swift
//  InstagramScrollView
//
//  Created by Jason Park on 4/6/18.
//  Copyright © 2018 Jason Park. All rights reserved.
//

import UIKit
import Firebase

class DescriptionController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        //Save image into Firebase Storage
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postsRef = ref.child("posts")
        
        let storageRef = Storage.storage().reference()
        let uploadData = UIImagePNGRepresentation(PreviewImage.shared.image!)
        
        let fileName = UUID().uuidString
        
        storageRef.child(fileName).putData(uploadData!, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                print(error)
                return
            }
            print(metadata)
            postsRef.child(fileName).updateChildValues(["downloadUrl": metadata?.downloadURL()?.absoluteString])
        })
        

        //Update user node
        let usersRef = ref.child("users").child(uid)
        let timestamp = NSDate().timeIntervalSince1970
        usersRef.child("posts").child(fileName).updateChildValues(["timestamp": timestamp])

        //Update posts node
        postsRef.child(fileName).updateChildValues(["timestamp": timestamp, "description": ""])
        
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = PreviewImage.shared.image
        }
    
}
