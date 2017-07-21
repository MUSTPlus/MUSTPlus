//
//  UIView+QHUIViewCtg.h
//  QHCategorys
//
//  Created by imqiuhang on 15/2/10.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "QHHead.h"

@interface UIView (QHUIViewCtg)

///如需将x,y将向上取整数 如 1.3f~>2.f  则在.m中加上ceilf(x 'or' y);
- (CGFloat)left;
- (void)setLeft:(CGFloat)x;
- (CGFloat)top;
- (void)setTop:(CGFloat)y;
- (CGFloat)right;
- (void)setRight:(CGFloat)right;
- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;

- (CGFloat)centerX;
- (void)setCenterX:(CGFloat)centerX;
- (CGFloat)centerY;
- (void)setCenterY:(CGFloat)centerY;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)origin;
- (CGSize)size;
- (void)setSize:(CGSize)size;

- (void)removeAllSubviews;
- (void)removeAllGestureRecognizers;

///截图
- (UIImage *)screenshotWithQuality:(CGFloat)imageQuality;

- (void)setAsStarView:(float)starCount;


@end
