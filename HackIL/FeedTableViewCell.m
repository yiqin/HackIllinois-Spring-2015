//
//  FeedTableViewCell.m
//  HackIL
//
//  Created by Yi Qin on 2/28/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "FeedTableViewCell.h"
#import "AFNetworking.h"

@implementation FeedTableViewCell

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.displayImageView = [[UIImageView alloc] init];
        [self addSubview:self.displayImageView];
        
        
    }
    return self;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setContentValue:(Feed *)feed {
    if (feed.coverImage.isLoading) {
        
        /*
        NSString *tempString = [NSString stringWithFormat:@"%@", feed.coverImage.file.url];
        
        
        AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
        [operationManager GET:@"http://files.parsetfss.com/80bf5d55-10a8-400f-8ee6-56ba5df99927/tfss-faa505e5-ea82-4a96-b3ea-e2c572f4fc03-Cityscape_12.14_by_thejunglephoto.pw.jpg" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        */
        
        PFImageView *pfImageView = [[PFImageView alloc] init];
        pfImageView.file = feed.coverImage.file;
        [pfImageView loadInBackground:^(UIImage *image, NSError *error) {
            NSLog(@"successfully loading");
        }];
        
        
        
        
    }
    else {
        NSLog(@"assign the image");
        self.displayImageView.image = feed.coverImage.image;
    }
    
    
}

- (void)layoutSubviews {
    self.displayImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight {
    return 330;
}

@end
