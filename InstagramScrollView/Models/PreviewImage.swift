//
//  PreviewImage.swift
//  InstagramScrollView
//
//  Created by Jason Park on 4/8/18.
//  Copyright © 2018 Jason Park. All rights reserved.
//

import UIKit

class PreviewImage: NSObject {
    
    static let shared = PreviewImage()
    fileprivate override init() {}
    
    var image: UIImage?
    
}
