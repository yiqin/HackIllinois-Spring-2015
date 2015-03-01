//
//  PostingView.h
//  HackIL
//
//  Created by Yi Qin on 3/1/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYVibrantButton.h"

@interface PostingView : UIView

@property(nonatomic, strong) UILabel *introLabel;
@property(nonatomic, strong) UITextView *tf;
@property(nonatomic, strong) UILabel *introPlaceLabel;

@property(nonatomic, strong) UILabel *placeLabel;

@property(nonatomic, strong) UIImageView *photoImageView;

@property(nonatomic, strong) AYVibrantButton *getButton;

@end
