//
//  ToPostTableViewCell.m
//  HackIL
//
//  Created by Yi Qin on 2/28/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "ToPostTableViewCell.h"
#import <Colours.h>

@interface ToPostTableViewCell ()



@end

@implementation ToPostTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.textField = [[UITextField alloc] init];
        self.textField.textColor = [UIColor colorFromHexString:@"4d4d4d"];
        self.textField.placeholder = @"Search";
        self.textField.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
        self.textField.returnKeyType = UIReturnKeySearch;
        
        [self addSubview:self.textField];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews {
    self.textField.frame = CGRectMake(15, 0, self.frame.size.width-30, self.frame.size.height);
}

+ (CGFloat)cellHeight {
    return 50;
}

@end
