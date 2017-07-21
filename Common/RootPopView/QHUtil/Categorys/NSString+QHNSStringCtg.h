//
//  NSString+QHNSStringCtg.h
//  QHCategorys
//
//  Created by imqiuhang on 15/2/10.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#import "QHHead.h"

@interface NSString (QHNSStringCtg)

///去除空格判断是否为空
- (BOOL)isNotEmptyCtg;
///不去除空格判断是否为空
- (BOOL)isNotEmptyWithSpace;

///符号成套删除 可用于去除带有xml标记 如<color>
- (NSString*)stringByDeleteSignForm:(NSString *)aLeftSign
                       andRightSign:(NSString *)aRightSign;


- (NSString*)stringByReplacingSignForm:(NSString *)aLeftSign
                          andRightSign:(NSString *)aRightSign
                       andReplacingStr:(NSString*)aReplacingStr;


- (NSString *)QHURLEncodedString;

- (NSURL *)qh_url;

@end
