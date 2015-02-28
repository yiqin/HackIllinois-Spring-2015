//
//  NSMutableSet+UniqueObject.m
//  HackIL
//
//  Created by Yi Qin on 2/28/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "NSMutableSet+UniqueObject.h"

@implementation NSMutableSet (UniqueObject)

- (void)addOrDeleteUniqueObject:(id)object {
    if ([self containsObject:object]) {
        [self removeObject:object];
    }
    else {
        [self removeAllObjects];
        [self addObject:object];
    }
}

@end
