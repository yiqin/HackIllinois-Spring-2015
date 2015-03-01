//
//  LikesManager.h
//
//
//  Created by Jocelyn on 2/28/15.
//
//

#import <Foundation/Foundation.h>

@interface LikesManager : NSObject {
    // NSMutableArray *likedList;
}
@property(nonatomic, strong) NSMutableArray *likedList;

+(id)sharedManager;
- (NSMutableArray*)loadLikes;
- (void)addLikes:(NSString*)likeID;
- (void)deleteLikes:(NSString *)likeID;
- (void)saveLikes;

@end
