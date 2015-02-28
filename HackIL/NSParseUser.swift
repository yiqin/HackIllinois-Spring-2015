//
//  NSParseUser.swift
//  HackIL
//
//  Created by Yi Qin on 2/28/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class NSParseUser: NSParseObject {
    
    var name:String
    var rawCoverImage:NSParseImage
    
    override init(parseObject: PFObject) {
        if let tempName = parseObject["name"] as? String {
            name = tempName
        }
        else {
            name = ""
        }
        println("name: \(name)")
        
        if let tempFile = parseObject["profileImage"] as? PFFile {
            rawCoverImage = NSParseImage(pffile: tempFile)
        }
        else {
            rawCoverImage = NSParseImage()
        }
        
        super.init(parseObject:parseObject)
        
        
    }
}
