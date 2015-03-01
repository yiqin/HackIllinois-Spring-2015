//
//  VoiceLabel.m
//  Voice
//
//  Created by yiqin on 11/9/14.
//  Copyright (c) 2014 yiqin. All rights reserved.
//

#import "YQLabel.h"

@implementation YQLabel

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        self.yqNumberOfLine = 0;
        [self setFrame:frame font:self.font text:text];
    }
    return self;
}

- (void)setFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text
{
    // or "[text length] <1"
    if (text == nil) {
        text = @"NULL";
    }
    self.font = font;
    self.text = text;
    self.numberOfLines = 0;
    CGFloat maxheight = 1024.0;
    [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, maxheight)];
    [self sizeToFit];
    CGFloat labelHeight = self.frame.size.height;
    
    if (self.yqNumberOfLine > 0) {
        UILabel *temp = [[UILabel alloc] initWithFrame:frame];
        temp.font = font;
        temp.text = @"One line good why";
        [temp sizeToFit];
        
        
        
        if (labelHeight > temp.frame.size.height*self.yqNumberOfLine) {
            labelHeight = temp.frame.size.height*self.yqNumberOfLine;
        }
    }
    else {
        
    }
    
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, labelHeight);
}

- (void)updateFrameWithText:(NSString *)text
{
    [self setFrame:self.frame font:self.font text:text];
}

@end
