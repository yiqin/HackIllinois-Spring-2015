//
//  FeedTableViewCell.m
//  HackIL
//
//  Created by Yi Qin on 2/28/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "FeedTableViewCell.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "RandomColorGenerator.h"

@interface FeedTableViewCell ()

@property(nonatomic) CGFloat profileSize;

@property(nonatomic, strong) UILabel *messageLabel;
@property(nonatomic, strong) UIImageView *displayImageView;

@property(nonatomic, strong) UIImageView *goingUserProfile1;

@property(nonatomic, strong) UILabel *timeLabel;

@end

@implementation FeedTableViewCell

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.profileSize = 85.0/2;
        
        self.displayImageView = [[UIImageView alloc] init];
        self.displayImageView.contentMode = UIViewContentModeCenter;
        self.displayImageView.clipsToBounds = YES;
        [self addSubview:self.displayImageView];
        
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.textColor = [UIColor whiteColor];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:17.0];
        [self addSubview:self.messageLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.numberOfLines = 1;
        self.timeLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0];
        [self addSubview:self.timeLabel];
        
        self.goingUserProfile1 = [[UIImageView alloc] init];
        self.goingUserProfile1.layer.masksToBounds = YES;
        self.goingUserProfile1.layer.cornerRadius = self.profileSize*0.5;
        [self addSubview:self.goingUserProfile1];
        
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setContentValue:(Feed *)feed {
    self.messageLabel.text = feed.name;
    self.timeLabel.text = feed.releasedAtString;
    NSLog(@"%@", self.timeLabel);
    
    if (feed.goingUsers.count > 0) {
        GoingUser *goingUser1 = [feed.goingUsers objectAtIndex:0];
        NSLog(@"goring user name %@", goingUser1.name);
        self.goingUserProfile1.image = goingUser1.rawCoverImage.image;
        NSLog(@"%f", self.goingUserProfile1.image.size.height);
        
    }
    
    if (feed.hasCoverImage) {
        if (feed.rawCoverImage.isLoading) {
            NSLog(@"load image in the cell.");
            NSString *tempString = [NSString stringWithFormat:@"%@", feed.rawCoverImage.file.url];
            AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
            operationManager.responseSerializer = [AFImageResponseSerializer serializer];
            [operationManager GET:tempString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                self.displayImageView.image = responseObject;
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
        else {
            self.displayImageView.image = feed.rawCoverImage.image;
        }
    }
    else {
        self.displayImageView.image = nil;
        self.displayImageView.backgroundColor = feed.backgroundSolidColor;
    }
    
}

- (void)layoutSubviews {
    // This will be a fixed size.
    CGFloat tempWidth = CGRectGetWidth(self.frame);
    CGFloat tempHeigth = CGRectGetHeight(self.frame);
    
    self.displayImageView.frame = CGRectMake(0, 0, tempWidth, [FeedTableViewCell cellHeight:NO]);
    
    self.messageLabel.frame = CGRectMake(40, 0, tempWidth-80, [FeedTableViewCell cellHeight:NO]);
    
    self.timeLabel.frame = CGRectMake(0, 65, tempWidth, 30);
    
    self.goingUserProfile1.frame = CGRectMake(40/2, tempHeigth-35/2-self.profileSize, self.profileSize, self.profileSize);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight:(BOOL) isClicked {
    CGFloat kScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    if (isClicked) {
        return kScreenWidth*kRatio+80;
    }
    else {
        return kScreenWidth*kRatio;
    }
}

@end
