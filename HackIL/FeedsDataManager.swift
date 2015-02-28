//
//  FeedsDataManager.swift
//  HackIL
//
//  Created by Yi Qin on 2/28/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class FeedsDataManager: NSObject {
    
    var objects : [Feed] = []
    var currentPageIndex = 0
    let itemsPerPage = 20
    
    class var sharedInstance : FeedsDataManager {
        struct Static {
            static let instance = FeedsDataManager()
        }
        return Static.instance
    }
    
    /**
    quick way to start to load article data from Parse.com
    */
    func startLoadingDataFromParse(pageIndex:Int) {
        startLoadingDataFromParse(pageIndex, completionClosure: { (success) -> () in
            
        })
    }
    
    /// with Closure............
    func startLoadingDataFromParse(pageIndex:Int, completionClosure: (success :Bool) ->()) {
        var query  = PFQuery(className: "Feed")
        
        query.orderByDescending("releasedAt")
        query.limit = itemsPerPage
        query.skip = pageIndex*itemsPerPage
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                println("Load data (DataManager) from Parse.com.")
                var recieved:[Feed] = []
                
                for object in objects {
                    let newFeed = Feed(parseObject: object as PFObject)
                    
                    newFeed.backgroundSolidColor = RandomColorGenerator.getColor()
                    
                    
                    recieved.append(newFeed)
                }
                
                if (pageIndex == 0){
                    self.objects = []
                }
                self.objects += recieved
                completionClosure(success: true)
                
            } else {
                NSLog("Error: %@ %@", error, error.userInfo!)
                completionClosure(success: false)
            }
        }
    }
    
    func loadMoreDataFromParse(completionClosure: (success :Bool) ->()){
        currentPageIndex++;
        startLoadingDataFromParse(currentPageIndex, completionClosure: { (success) -> () in
            if (success){
                completionClosure(success: true)
            }
            else {
                completionClosure(success: false)
            }
        })
    }

   
}
