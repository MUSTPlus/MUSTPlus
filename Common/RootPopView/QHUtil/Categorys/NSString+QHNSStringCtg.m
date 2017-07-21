//
//  NSString+QHNSStringCtg.m
//  QHCategorys
//
//  Created by imqiuhang on 15/2/10.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#import "NSString+QHNSStringCtg.h"

@implementation NSString (QHNSStringCtg)

- (BOOL)isNotEmptyCtg {
    if (!self) {
        return NO;
    }
    if ([NSNull null] == (id)self) {
        return NO;
    }

    NSString *curStr = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([curStr isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isNotEmptyWithSpace {
    if (!self) {
        return NO;
    }
    if ([self isEqualToString:@""]) {
        return NO;
    }
    
    return YES;

}

- (NSString*)stringByDeleteSignForm:(NSString *)aLeftSign
                       andRightSign:(NSString *)aRightSign {
   return  [self stringByReplacingSignForm:aLeftSign andRightSign:aRightSign andReplacingStr:@""];
}

- (NSString*)stringByReplacingSignForm:(NSString *)aLeftSign
                          andRightSign:(NSString *)aRightSign
                       andReplacingStr:(NSString*)aReplacingStr {
    
    NSString *curStr   = self;
    
    NSRange rangeLeft  = [curStr rangeOfString:aLeftSign];
    NSRange rangeRight = [curStr rangeOfString:aRightSign];
    
    while (rangeLeft.location!=NSNotFound&&rangeRight.location!=NSNotFound&&rangeRight.location>rangeLeft.location) {
        
        NSRange cutRange = NSMakeRange(rangeLeft.location, rangeRight.location-rangeLeft.location+1);
        curStr           =[curStr stringByReplacingCharactersInRange:cutRange withString:aReplacingStr];
        rangeLeft        =[curStr rangeOfString:aLeftSign];
        rangeRight       =[curStr rangeOfString:aRightSign];
    }
    
    return curStr;
}


- (NSString *)QHURLEncodedString {
    
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8));
    return outputStr;
}

- (NSURL *)qh_url {
    if ([self isKindOfClass:[NSURL class]]) {
        return (NSURL *)self;
    }
    
    NSString * encodingString = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:encodingString];
}


@end
#pragma clang diagnostic pop
