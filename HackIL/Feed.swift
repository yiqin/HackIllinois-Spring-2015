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
    
    var releasedAtString : String
    
    var goingUsers:[GoingUser] = []
    
    var backgroundSolidColor : UIColor = UIColor.whiteColor()
    
    var geoPoint : PFGeoPoint
    var hasGeoPoint : Bool
    
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
            releasedAtString = releasedAt.timeAgoSinceNow()
        }
        else {
            releasedAt = NSDate()
            releasedAtString = ""
        }
        
        if let tempGeopoint = parseObject["geopoint"] as? PFGeoPoint {
            geoPoint = tempGeopoint
            hasGeoPoint = true;
        }
        else {
            geoPoint = PFGeoPoint()
            hasGeoPoint = false;
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
                    
                    let tempPFObject = object as PFObject
                    let goingUser = GoingUser(parseObject: tempPFObject)
                    
                    
                    
                    println("Find users........")
                    self.goingUsers += [goingUser]
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
