//
//  PostingView.m
//  HackIL
//
//  Created by Yi Qin on 3/1/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "PostingView.h"
#import <Colours.h>
#import <Parse/Parse.h>

@interface PostingView ()



@end

@implementation PostingView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorFromHexString:@"3d5fc4"];
        
        self.photoImageView = [[UIImageView alloc] init];
        self.photoImageView.hidden = NO;
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
        
        
        
        
        CGFloat buttonWidth = 180;
        CGFloat buttonHeight = 44;
        self.getButton = [[AYVibrantButton alloc] initWithFrame:CGRectMake(0.5*CGRectGetWidth(self.frame)-buttonWidth*0.5, 420, buttonWidth, buttonHeight) style:AYVibrantButtonStyleInvert];
        self.getButton.backgroundColor = [UIColor colorFromHexString:@"ffb745"];
        // self.getButton.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        self.getButton.vibrancyEffect = nil;
        self.getButton.text = @"I'M LUCKY";
        self.getButton.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:17.0];
        
        
        self.getButton.cornerRadius = buttonHeight*0.5;
        self.getButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        
        [self.getButton addTarget:self action:@selector(goToAppStore:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.getButton];
        
        
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(hideKeyBoard)];
        // [self addGestureRecognizer:tapGesture];
        [self.photoImageView setUserInteractionEnabled:YES];
        [self.photoImageView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)goToAppStore:(UIButton*)button {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"savePost" object:nil];
}

-(void)hideKeyBoard {
    [self.tf resignFirstResponder];
}

-(void)layoutSubviews {
    self.photoImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
}



@end
