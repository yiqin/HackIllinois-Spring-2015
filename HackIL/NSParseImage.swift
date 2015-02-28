//
//  NSParseImage.swift
//  HackIL
//
//  Created by Yi Qin on 2/28/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

/// General image class. It has isLoading, image and file three properties.
class NSParseImage: NSObject {
    
    var image : UIImage
    var isLoading : Bool
    var file : PFFile
    
    init(pffile : PFFile) {
        image = UIImage()
        isLoading = true
        file = pffile
        
        super.init()
        
        let manager = AFHTTPRequestOperationManager()
        /*
        let tempImagePFImageView = PFImageView()
        tempImagePFImageView.file = pffile
        tempImagePFImageView.loadInBackground { (image:UIImage!, error:NSError!) -> Void in
            if ((error) == nil){
                self.image = image
                self.isLoading = false
                println("test image")
            }
        }
        */
    }
    

}
