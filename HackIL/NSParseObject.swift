//
//  NSParseObject.swift
//  HackIL
//
//  Created by Yi Qin on 2/27/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class NSParseObject: NSObject {
    
    /// unique id on Parse
    var objectId: NSString
    /// created time on Parse
    var createdAt: NSDate
    /// latest updated time on Parse
    var updatedAt: NSDate
    /// the whole PFObject on Parse
    var parseObject: PFObject
    
    init(parseObject:PFObject) {
        objectId = parseObject.objectId
        createdAt = parseObject.createdAt
        updatedAt = parseObject.updatedAt
        self.parseObject = parseObject
        super.init()
    }
    
    init(parseClassName:String){
        objectId = ""
        createdAt = NSDate()
        updatedAt = NSDate()
        parseObject = PFObject(className: parseClassName)
        super.init()
    }
    
   
}
