//
//  HeiHei.m
//  MUST_Plus
//
//  Created by zbc on 16/10/7.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "HeiHei.h"
#define XOR_KEY 0X22

//key = 


@implementation HeiHei

void xorString(unsigned char *str, unsigned char key)
{
    unsigned char *p = str;
    while( ((*p) ^=  key) != '\0')  p++;
}
    
+ (NSString *)toeknNew_key
    {
        unsigned char str[] =
            {
            };
        xorString(str, XOR_KEY);
        static unsigned char result[16];
        memcpy(result, str, 16);
        return [NSString stringWithFormat:@"%s",result];
}
    
@end
