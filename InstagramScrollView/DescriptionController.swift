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
        //Main reference
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //Sub node references
        let usersRef = ref.child("users").child(uid)
        let postsRef = ref.child("posts")
        
        //Save image into Firebase Storage
        let storageRef = Storage.storage().reference()
        let uploadData = UIImagePNGRepresentation(PreviewImage.shared.image!)
        
        let fileName = UUID().uuidString

        
        //Update nodes
        storageRef.child(fileName).putData(uploadData!, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                print(error)
                return
            }
            //Update posts node
            let timestamp = NSDate().timeIntervalSince1970
            postsRef.child(fileName).updateChildValues(["downloadUrl": metadata?.downloadURL()?.absoluteString, "timestamp": timestamp, "description": ""])
            //Update user node
            usersRef.child("posts").child(fileName).updateChildValues(["timestamp": timestamp])
        })
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = PreviewImage.shared.image
        }
    
}
