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
        let storageRef = Storage.storage().reference()
//        let uploadData = UIImagePNGRepresentation(selectedImage!)
        
        let fileName = UUID().uuidString
        
//        storageRef.child(fileName).putData(uploadData!, metadata: nil, completion: { (metadata, error) in
//            if error != nil {
//                print(error)
//                return
//            }
//            
//        })
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "")
        }
    
}
