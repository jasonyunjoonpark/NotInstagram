//
//  HomeController+handlers.swift
//  InstagramScrollView
//
//  Created by Jason Park on 4/6/18.
//  Copyright © 2018 Jason Park. All rights reserved.
//

import UIKit
import Firebase
extension HomeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //Upload Image Button Pressed
    @objc func handleUploadImageButtonPressed() {
        let photoLibrarySelectorVC = UIImagePickerController()
        
        photoLibrarySelectorVC.delegate = self
        photoLibrarySelectorVC.allowsEditing = true
        
        present(photoLibrarySelectorVC, animated: true, completion: nil)
    }
    
    //Image Picker Controller 'Cancel' Button Pressed
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    //Image Picker Controller 'Choose' Button Pressed
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage: UIImage?
        let myGroup = DispatchGroup()
        
        myGroup.enter()
        //Check if user edited image or not, then store into variable: selectedImage
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        
        picker.dismiss(animated: true, completion: nil)

        myGroup.leave()
        
        
        //Store user selected image into Firebase Storage after completion of storing user selected image into variable: selectedImage
        myGroup.notify(queue: .main) {
            
            let descriptionVC: DescriptionController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "descriptionController") as UIViewController as! DescriptionController
            
            self.present(descriptionVC, animated: true, completion: nil)

            
            let storageRef = Storage.storage().reference()
            let uploadData = UIImagePNGRepresentation(selectedImage!)
            
            let fileName = UUID().uuidString
            
            storageRef.child(fileName).putData(uploadData!, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error)
                    return
                }
                
            })
            
        }


        


    }
    
    
    
}
