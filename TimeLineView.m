//
//  TimeLineView.m
//  AttendanceCenter
//
//  Created by admin on 16/3/17.
//  Copyright © 2016年 drmshow. All rights reserved.
//

#import "TimeLineView.h"

#define kColorValue(value)  value/255.0

@implementation TimeLineView

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat centerX = self.center.x;
    CGFloat height = self.frame.size.height;
    CGContextMoveToPoint(ctx, centerX, 0.0);
    CGContextAddLineToPoint(ctx, centerX, height);
    [[UIColor colorWithRed:kColorValue(190) green:kColorValue(190) blue:kColorValue(190) alpha:1] setStroke];
    CGContextSetLineWidth(ctx, 4);
    CGContextStrokePath(ctx);
}

@end
