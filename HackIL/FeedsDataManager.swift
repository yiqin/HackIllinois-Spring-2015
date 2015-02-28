//
//  FeedsDataManager.swift
//  HackIL
//
//  Created by Yi Qin on 2/28/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class FeedsDataManager: NSObject {
    
    // we need a mutable array here.
    var currentPageIndex = 0;
    let itemsPerPage = 10;
    
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
        
        query.orderByDescending("createdAt")
        query.limit = itemsPerPage
        query.skip = pageIndex*itemsPerPage
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                println("Load data (DataManager) from Parse.com.")
                var recieved = NSMutableArray()
                
                for object in objects {
                    let newFeed = Feed(parseObject: object as PFObject)
                    // recievedArticles.addObject(newArtical)
                }
                
                if (pageIndex == 0){
                    // self.articles.removeAllObjects()
                }
                // self.articles.addObjectsFromArray(recievedArticles)
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
