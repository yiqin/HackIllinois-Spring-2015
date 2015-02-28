//
//  NSMutableSet+UniqueObject.h
//  HackIL
//
//  Created by Yi Qin on 2/28/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableSet (UniqueObject)

- (void)addOrDeleteUniqueObject:(id)object;

@end
