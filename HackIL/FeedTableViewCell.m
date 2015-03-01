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
#import "YQLabel.h"
#import "LikesManager.h"

@interface FeedTableViewCell ()

@property(nonatomic) CGFloat profileSize;
@property(nonatomic) CGFloat profileSizeSmall;

@property(nonatomic, strong) YQLabel *messageLabel;
@property(nonatomic, strong) UIImageView *displayImageView;
@property(nonatomic, strong) Feed *feed;

@property(nonatomic, strong) UIView *filterView;

// #1
@property(nonatomic, strong) UIImageView *goingUserProfile1;
@property(nonatomic, strong) UIImageView *goingUserProfile2;
@property(nonatomic, strong) UIImageView *goingUserProfile3;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) UILabel *nameHolder;
@property(nonatomic, strong) UIButton *ghost;
@property(nonatomic, strong) UIImageView *likes;

@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic) BOOL currStatus;

@end

@implementation FeedTableViewCell

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.profileSize = 85.0/2;
        self.profileSizeSmall = 60.0/2;
        
        self.displayImageView = [[UIImageView alloc] init];
        self.displayImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.displayImageView.clipsToBounds = YES;
        [self addSubview:self.displayImageView];
        
        self.filterView = [[UIView alloc] init];
        self.filterView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.filterView.hidden = YES;
        [self addSubview:self.filterView];
        
        self.messageLabel = [[YQLabel alloc] init];
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
        
        
        // #2
        self.goingUserProfile1 = [[UIImageView alloc] init];
        self.goingUserProfile1.contentMode = UIViewContentModeScaleAspectFill;
        self.goingUserProfile1.layer.masksToBounds = YES;
        self.goingUserProfile1.layer.cornerRadius = self.profileSize*0.5;
        [self addSubview:self.goingUserProfile1];
        
        self.nameHolder = [[UILabel alloc] init];
        self.nameHolder.numberOfLines = 0;
        [self addSubview:self.nameHolder];
        
        self.goingUserProfile2 = [[UIImageView alloc] init];
        self.goingUserProfile2.contentMode = UIViewContentModeScaleAspectFill;
        self.goingUserProfile2.layer.masksToBounds = YES;
        self.goingUserProfile2.layer.cornerRadius = self.profileSizeSmall*0.5;
        [self addSubview:self.goingUserProfile2];
        
        self.goingUserProfile3 = [[UIImageView alloc] init];
        self.goingUserProfile3.contentMode = UIViewContentModeScaleAspectFill;
        self.goingUserProfile3.layer.masksToBounds = YES;
        self.goingUserProfile3.layer.cornerRadius = self.profileSizeSmall*0.5;
        [self addSubview:self.goingUserProfile3];
        
        self.likes = [[UIImageView alloc] init];
        [self addSubview:self.likes];
        
        self.ghost =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.ghost addTarget:self action:@selector(ghostPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.ghost];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setContentValue:(Feed *)feed {
    self.feed = feed;
    NSString *feedID = feed.objectId;
    self.currStatus = [self LikeStatus:feedID];
    
    self.messageLabel.text = feed.name;
    self.timeLabel.text = feed.releasedAtString;
    NSLog(@"%@", self.timeLabel);
    
    self.goingUserProfile1.image = nil;
    self.goingUserProfile2.image = nil;
    self.goingUserProfile3.image = nil;
    
    
    // #3
    if (feed.goingUsers.count >= 1) {
        GoingUser *goingUser1 = [feed.goingUsers objectAtIndex:0];
        NSLog(@"goring user name %@", goingUser1.name);
        self.userName = goingUser1.name;
        self.nameHolder.text = self.userName;
        self.nameHolder.textColor = [UIColor whiteColor];
        self.nameHolder.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:12];
        self.goingUserProfile1.image = goingUser1.rawCoverImage.image;
        NSLog(@"%f", self.goingUserProfile1.image.size.height);
    }
    if (feed.goingUsers.count >= 2) {
        GoingUser *goingUser2 = [feed.goingUsers objectAtIndex:1];
        NSLog(@"goring user name %@", goingUser2.name);
        self.goingUserProfile2.image = goingUser2.rawCoverImage.image;
        NSLog(@"%f", self.goingUserProfile2.image.size.height);
    }
    if (feed.goingUsers.count >= 3) {
        GoingUser *goingUser3 = [feed.goingUsers objectAtIndex:2];
        NSLog(@"goring user name %@", goingUser3.name);
        self.goingUserProfile3.image = goingUser3.rawCoverImage.image;
        NSLog(@"%f", self.goingUserProfile3.image.size.height);
    }
    
    
    if (feed.hasCoverImage) {
        if (feed.rawCoverImage.isLoading) {
            NSLog(@"load image in the cell.");
            NSString *tempString = [NSString stringWithFormat:@"%@", feed.rawCoverImage.file.url];
            AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
            operationManager.responseSerializer = [AFImageResponseSerializer serializer];
            [operationManager GET:tempString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                self.displayImageView.image = responseObject;
                self.filterView.hidden = NO;
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
        else {
            self.displayImageView.image = feed.rawCoverImage.image;
            self.filterView.hidden = NO;
        }
    }
    else {
        self.displayImageView.image = nil;
        self.filterView.hidden = YES;
        self.displayImageView.backgroundColor = feed.backgroundSolidColor;
    }
    
    if (self.currStatus) {
        [self.likes setImage:[UIImage imageNamed:@"favourite-active.png"]];
    }
    else {
        [self.likes setImage:[UIImage imageNamed:@"favorite.png"]];
    }
    
    [self.likes setBackgroundColor:[UIColor clearColor]];
    

}

- (void)layoutSubviews {
    // This will be a fixed size.
    CGFloat tempWidth = CGRectGetWidth(self.frame);
    CGFloat tempHeigth = [FeedTableViewCell cellHeight:NO];
    
    self.displayImageView.frame = CGRectMake(0, 0, tempWidth, tempHeigth);
    self.filterView.frame = CGRectMake(0, 0, tempWidth, tempHeigth);
    self.messageLabel.frame = CGRectMake(40, 0, tempWidth-80, tempHeigth);
    
    
    
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame: CGRectMake(40, 0, tempWidth-80, tempHeigth)];
    tempLabel.text = self.messageLabel.text;
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.numberOfLines = 0;
    tempLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:17.0];
    
    NSLog(@"%@", tempLabel.text);
    [tempLabel sizeToFit];
    CGFloat tempHeight1 = ([FeedTableViewCell cellHeight:NO]-CGRectGetHeight(tempLabel.frame))*0.5;
    
    NSLog(@"tempHeight1    %f", tempHeight1);
    
    
    
    // [self.messageLabel sizeToFit];
    // self.messageLabel.backgroundColor = [UIColor whiteColor];
    
    // self.messageLabel.center  = CGSizeMake(<#CGFloat width#>, )
    
    self.timeLabel.frame = CGRectMake(0, tempHeight1-30, tempWidth, 30);
    
    
    // #4
    self.goingUserProfile1.frame = CGRectMake(40/2, tempHeigth-35/2-self.profileSize, self.profileSize, self.profileSize);
    
    self.nameHolder.frame = CGRectMake(40/2+50, tempHeigth-35/2-self.profileSize-8, self.profileSize+4, self.profileSize);
    
    self.nameHolder.frame = CGRectMake(40/2+50+60, tempHeigth-35/2-self.profileSize-5, self.profileSize, self.profileSize);
    
    self.goingUserProfile2.frame = CGRectMake(40/2+50+60*2, CGRectGetMinY(self.goingUserProfile1.frame)+self.profileSize - self.profileSizeSmall, self.profileSizeSmall, self.profileSizeSmall);
    //*layout
    self.goingUserProfile3.frame = CGRectMake(40/2+50+60+self.profileSizeSmall*1.2, CGRectGetMinY(self.goingUserProfile1.frame)+self.profileSize - self.profileSizeSmall, self.profileSizeSmall, self.profileSizeSmall);
    
    self.likes.frame = CGRectMake(40/2+50+60*4, tempHeigth-35/2-self.profileSize + self.profileSize/2 - 13.5, 28, 27); //x, y, width, height
    self.ghost.frame = CGRectMake(40/2+50+60*4, tempHeigth-35/2-self.profileSize, self.profileSize, self.profileSize);

}

-(void)ghostPressed:(UIButton*)sender
{
    LikesManager *singleton = [LikesManager sharedManager];
    //   NSMutableArray *myLikes = [singleton loadLikes];
    NSLog(@"currentstatus: %d", self.currStatus);
    if (self.currStatus == NO) {
        [UIImageView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear                      animations:^{
            [self.likes setImage:[UIImage imageNamed:@"favourite-active.png"]];
            self.likes.transform = CGAffineTransformScale(self.likes.transform, 1.0, 1.0);
            NSLog(@"currStatusNo");
            
        }
                              completion:^(BOOL completed) {
                                  [UIImageView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear
                                                        animations:^{
                                                            self.likes.transform =
                                                            CGAffineTransformScale(self.likes.transform, 0.5, 0.5);
                                                        }
                                                        completion:^(BOOL finished) {
                                                            
                                                        }];
                                  
                              }];
        [singleton addLikes:self.feed.objectId];
        [singleton saveLikes];
        _currStatus = YES;
        NSMutableArray *data = [singleton loadLikes];
        NSLog(@"loadid: %@", self.feed.objectId);
        NSLog(@"loaddatano: %@", data);
        
    }
    else {
        [UIImageView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear                      animations:^{
            [self.likes setImage:[UIImage imageNamed:@"favorite.png"]];
            self.likes.transform = CGAffineTransformScale(self.likes.transform, 1.0,1.0);
            
            
        }
                              completion:^(BOOL completed) {
                                  [UIImageView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear
                                                        animations:^{
                                                            self.likes.transform =
                                                            CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
                                                            
                                                        }
                                                        completion:^(BOOL finished) {
                                                            
                                                        }];
                                  
                              }];
        [singleton deleteLikes:self.feed.objectId];
        _currStatus = NO;
        
    }
}

-(BOOL)LikeStatus:(NSString*)feedID {
    BOOL status = NO;
    LikesManager *singleton = [LikesManager sharedManager];
    [singleton loadLikes];
    
    // [[FeedsDataManager sharedInstance].objects objectAtIndex:]
    NSMutableArray *myLikes = [[NSMutableArray alloc]init];
    myLikes = [singleton loadLikes];
    NSLog(@"mylikes %@", myLikes);
    NSUInteger size = [myLikes count];
    for (int i = 0; i < size; i++) {
        NSString *currLike = [myLikes objectAtIndex:i];
        if ([currLike isEqualToString: feedID]) {
            status = YES;
        }
        
    }
    NSLog(@"likestatus: %d",status);
    return status;
    
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
