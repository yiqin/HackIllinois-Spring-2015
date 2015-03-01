//
//  FeedTableViewCell.h
//  HackIL
//
//  Created by Yi Qin on 2/28/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HackIL-Swift.h>
#import <Parse/PFFile.h>
#import <PFImageView.h>

@interface FeedTableViewCell : UITableViewCell



- (void)setContentValue:(Feed *)feed withCheckingCliked:(BOOL) isClicked;

+ (CGFloat)cellHeight:(BOOL) isClicked;

@end
