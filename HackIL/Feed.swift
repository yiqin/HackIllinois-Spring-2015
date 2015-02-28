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
    
    var releasedAt : NSDate
    
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
        
        if let tempReleasedAt = parseObject["releasedAt"] as? NSDate {
            releasedAt = tempReleasedAt
        }
        else {
            releasedAt = NSDate()
        }
        
        super.init(parseObject:parseObject)
        
        
        startToLoadGoingUsers()
        
        
        
    }
    
    func startToLoadGoingUsers(){
        var query = PFQuery(className: "Going")
        query.whereKey("feed", equalTo: self.parseObject)
        query.orderByAscending("releasedAt")
        
        println("starting.........")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                println("successullly get Articles")
                
                // Only call this notification one time...
                NSNotificationCenter.defaultCenter().postNotificationName("reloadSessionStreetImageTableViewCell", object: nil, userInfo: nil)
                
                for object in objects {
                    // let article = Article(parseObject: object as PFObject)
                    // self.articles += [article]
                    
                }
                
                /*
                self.startToLoadCoverImage()
                

                
                */
                
                
                
            } else {
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    
    
}
