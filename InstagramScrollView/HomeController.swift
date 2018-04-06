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


    
    @IBAction func uploadImageButtonPressed(_ sender: Any) {
        perform(#selector(handleUploadImageButtonPressed))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().signInAnonymously() { (user, error) in

        }
        //perform(#selector(handleAddPictureButtonPressed))
    }



    

}

