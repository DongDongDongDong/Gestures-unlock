//
//  BackGroundView.m
//  12-31手势解锁
//
//  Created by apple on 14-12-31.
//  Copyright (c) 2014年 Ai. All rights reserved.
//

#import "BackGroundView.h"

@implementation BackGroundView


- (void)drawRect:(CGRect)rect {
    UIImage *img = [UIImage imageNamed:@"Home_refresh_bg"];
    [img drawInRect:rect];
    
}


@end
