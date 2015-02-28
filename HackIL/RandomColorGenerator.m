//
//  RandomColorGenerator.m
//  HackIL
//
//  Created by Yi Qin on 2/28/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "RandomColorGenerator.h"
#import <Colours.h>

@implementation RandomColorGenerator


+(NSArray *)getColorsArrays {
    UIColor *color1 = [UIColor colorFromHexString:@"fab03a"];
    
    NSArray *colors = [[NSArray alloc] initWithObjects:color1, nil];
    
    return colors;
}
/*
+(UIColor *)getNextRandomColor:(int colorIndex){
    
}
*/
@end
