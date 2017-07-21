//
//  UIImage+X.h
//  MUST_Plus
//
//  Created by Cirno on 16/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIImage (X)

//加载全屏的图片
+(UIImage *)fullScreenImage:(NSString *)imageName;

//可以自由拉伸不会变形的图片
+(UIImage *)resizedImage:(NSString *)imageName;

//pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imageName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

+ (instancetype)imageWithStretchableName:(NSString *)imageName;

+ (instancetype)resizableWithImageName:(NSString *)imageName;

@end
