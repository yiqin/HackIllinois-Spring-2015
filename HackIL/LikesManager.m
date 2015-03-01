//
//  LikesManager.m
//
//
//  Created by Jocelyn on 2/28/15.
//
//

#import "LikesManager.h"

@implementation LikesManager


+(id)sharedManager {
    static LikesManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init
{
    if ( self = [super init] ) {
        _likedList = [[NSMutableArray alloc]init];
        NSLog(@"init:%@", _likedList);
    }
    NSLog(@"init else:%@", _likedList);
    return self;
}

- (NSMutableArray*)loadLikes {
    NSLog(@"loadlikes begin: %@", _likedList);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _likedList = [defaults objectForKey:@"likes"];
    NSLog(@"loadlikes else: %@", _likedList);
    if (_likedList == nil) {
        _likedList= [[NSMutableArray alloc] init];
        NSLog(@"loadlikes:%@", _likedList);
    }
    
    
    NSLog(@"loadlikes return: %@", _likedList);
    return _likedList;
    
}

- (void)addLikes:(NSString *)likeID {
    // _likedList = [[NSMutableArray alloc]init];
    NSLog(@"addlikes before:%@", _likedList);
    _likedList = [self loadLikes];
    NSLog(@"addlikes afterload:%@", _likedList);
    NSLog(@"addlike likeid:%@", likeID);
    NSArray *tempArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"likes"];
    _likedList = [tempArray mutableCopy];
    [_likedList addObject:likeID];
    NSLog(@"addlikes:%@", _likedList);
    [self saveLikes];
}

-(void)saveLikes {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_likedList forKey:@"likes"];
    [defaults synchronize];
    
}

- (void)deleteLikes:(NSString *)likeID {
    _likedList = [self loadLikes];
    NSArray *tempArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"likes"];
    _likedList = [tempArray mutableCopy];
    [_likedList removeObject:likeID];
    NSLog(@"addlikes:%@", _likedList);
    [self saveLikes];
    
    
}

@end
