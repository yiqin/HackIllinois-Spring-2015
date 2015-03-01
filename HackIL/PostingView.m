//
//  PostingView.m
//  HackIL
//
//  Created by Yi Qin on 3/1/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "PostingView.h"
#import <Colours.h>
@interface PostingView ()

@property(nonatomic, strong) UILabel *introLabel;
@property(nonatomic, strong) UITextView *tf;

@property(nonatomic, strong) UILabel *introPlaceLabel;

@end

@implementation PostingView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorFromHexString:@"3d5fc4"];\
        
        self.photoImageView = [[UIImageView alloc] initWithFrame:frame];
        self.photoImageView.hidden = YES;
        [self addSubview: self.photoImageView];
        
        self.introLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(frame), 20)];
        self.introLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:17.0];
        self.introLabel.textColor = [UIColor whiteColor];
        self.introLabel.text = @"What you up to?";
        self.introLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.introLabel];
        
        self.tf = [[UITextView alloc] initWithFrame:CGRectMake(50, 110, CGRectGetWidth(frame)-100, 80)];
        self.tf.textColor = [UIColor whiteColor];
        self.tf.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
        self.tf.backgroundColor=[UIColor clearColor];
        self.tf.textAlignment = NSTextAlignmentCenter;
        self.tf.text=@"";
        [self addSubview:self.tf];
        
        self.introPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 230, CGRectGetWidth(frame), 20)];
        self.introPlaceLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:17.0];
        self.introPlaceLabel.textColor = [UIColor whiteColor];
        self.introPlaceLabel.text = @"Where?";
        self.introPlaceLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.introPlaceLabel];
        
    }
    return self;
}

-(void)layoutSubviews {
    
}

@end
