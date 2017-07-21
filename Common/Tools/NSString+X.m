//
//  NSString+X.m
//  MUST_Plus
//
//  Created by Cirno on 16/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//


#import "NSString+X.h"

@implementation NSString (X)

-(NSString *)fileAppend:(NSString *)append
{
    //1.1获得文件扩展名
    NSString *ext = [self pathExtension];
    //1.2删除最后面的扩展名
    NSString *imageName = [self stringByDeletingPathExtension];
    
    //1.3拼接append
    imageName = [imageName stringByAppendingString:append];
    
    //1.4拼接扩展名
    imageName = [imageName stringByAppendingPathExtension:ext];
    
    return imageName;
}

@end
