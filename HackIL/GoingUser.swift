//
//  GoingUser.swift
//  HackIL
//
//  Created by Yi Qin on 2/28/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class GoingUser: NSParseObject {
    
    var name : String
    var rawCoverImage:NSParseImage
    
    
    override init(parseObject: PFObject) {
        
        if let tempName = parseObject["user_name"] as? String {
            name = tempName
        }
        else {
            name = ""
        }
        
        if let tempFile = parseObject["user_profileImage"] as? PFFile {
            rawCoverImage = NSParseImage(pffile: tempFile)
            println("In GoingUser.........")
        }
        else {
            rawCoverImage = NSParseImage()
            println("In GoingUser.........  NO file.... to load")
        }
        
        super.init(parseObject: parseObject)
        println(objectId)
    }
    

}
