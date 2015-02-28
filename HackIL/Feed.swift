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
    
    var hasCoverImage : Bool
    
    var rawCoverImage:NSParseImage
    
    override init(parseObject: PFObject) {
        if let tempName = parseObject["name"] as? String {
            name = tempName
        }
        else {
            name = ""
        }
        
        if let tempFile = parseObject["image"] as? PFFile {
            hasCoverImage = true
            rawCoverImage = NSParseImage(pffile: tempFile)
            
        }
        else {
            hasCoverImage = false
            rawCoverImage = NSParseImage()
        }
        
        super.init(parseObject:parseObject)
        
        
        
    }
    
    
}
