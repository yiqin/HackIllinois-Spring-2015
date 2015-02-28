//
//  GoingUser.swift
//  HackIL
//
//  Created by Yi Qin on 2/28/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class GoingUser: NSParseUser {
    
    var responsedAt: NSDate
    
    override init(parseObject: PFObject) {
        responsedAt = NSDate()
        super.init(parseObject: parseObject)
        println(objectId)
    }
    

}
