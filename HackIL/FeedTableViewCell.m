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

@interface FeedTableViewCell ()

@property(nonatomic, strong) UILabel *messageLabel;
@property(nonatomic, strong) UIImageView *displayImageView;

@end

@implementation FeedTableViewCell

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.displayImageView = [[UIImageView alloc] init];
        self.displayImageView.contentMode = UIViewContentModeCenter;
        self.displayImageView.clipsToBounds = YES;
        [self addSubview:self.displayImageView];
        
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.textColor = [UIColor whiteColor];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.numberOfLines = 0;
        [self addSubview:self.messageLabel];
        
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
        self.displayImageView.backgroundColor = [UIColor redColor];
    }
    
}

- (void)layoutSubviews {
    // This will be a fixed size.
    self.displayImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), [FeedTableViewCell cellHeight:NO]);
    
    self.messageLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), [FeedTableViewCell cellHeight:NO]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight:(BOOL) isClicked {
    CGFloat kScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    if (isClicked) {
        return kScreenWidth*kRatio+100;
    }
    else {
        return kScreenWidth*kRatio;
    }
}

@end
