//
//  Feed.swift
//  HackIL
//
//  Created by Yi Qin on 2/28/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class Feed: NSParseObject {
    
    var name:String
    
    var coverImage:NSParseImage
    
    override init(parseObject: PFObject) {
        if let tempName = parseObject["name"] as? String {
            name = tempName
        }
        else {
            name = ""
        }
        
        if let tempFile = parseObject["image"] as? PFFile {
            println("has an image to load")
            coverImage = NSParseImage(pffile: tempFile)
        }
        else {
            coverImage = NSParseImage()
        }
        
        super.init(parseObject:parseObject)
        
        
        
    }
    
    
}
