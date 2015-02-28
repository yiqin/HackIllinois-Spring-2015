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
    var croppedImage : UIImage
    
    var isLoading : Bool
    var file : PFFile
    
    init(pffile : PFFile) {
        image = UIImage()
        croppedImage = UIImage()
        isLoading = true
        file = pffile
        
        super.init()
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFImageResponseSerializer()
        manager.GET(file.url, parameters: nil, success: { (responseObject : AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            self.image = response as UIImage
            self.isLoading = false
            
            let tempImage = self.image
            let tempImageWidth = tempImage.size.width
            let tempImageHeight = tempImage.size.height
            
            let kScreenBounds = UIScreen.mainScreen().bounds
            let kScreenSize   = kScreenBounds.size
            let kScreenWidth  = kScreenSize.width
            let kScreenHeight = kScreenSize.height
            
            let ratio = kScreenWidth/tempImageWidth
            
            let scaledTempImage = tempImage.scaleToSize(CGSizeMake(kScreenWidth, tempImageHeight*ratio))
            let croppedTempImage = scaledTempImage.cropToSize(CGSizeMake(kScreenWidth, 100), usingMode: NYXCropModeCenter)
            self.croppedImage = croppedTempImage
            
            }) { (responseObject : AFHTTPRequestOperation!, error:NSError!) -> Void in
            
        }
    }
    
    override init(){
        image = UIImage()
        croppedImage = UIImage()
        isLoading = true
        file = PFFile()
        
        super.init()
    }
    

}
