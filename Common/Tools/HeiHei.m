//
//  HeiHei.m
//  MUST_Plus
//
//  Created by zbc on 16/10/7.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "HeiHei.h"
#define XOR_KEY 0X22

//key = 12%jBO*W5.EUT3WX


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
            (XOR_KEY ^ '1'),
            (XOR_KEY ^ '2'),
            (XOR_KEY ^ '%'),
            (XOR_KEY ^ 'j'),
            (XOR_KEY ^ 'B'),
            (XOR_KEY ^ 'O'),
            (XOR_KEY ^ '*'),
            (XOR_KEY ^ 'W'),
            (XOR_KEY ^ '5'),
            (XOR_KEY ^ '.'),
            (XOR_KEY ^ 'E'),
            (XOR_KEY ^ 'U'),
            (XOR_KEY ^ 'T'),
            (XOR_KEY ^ '3'),
            (XOR_KEY ^ 'W'),
            (XOR_KEY ^ 'X'),
            (XOR_KEY ^ '\0')
            };
        xorString(str, XOR_KEY);
        static unsigned char result[16];
        memcpy(result, str, 16);
        return [NSString stringWithFormat:@"%s",result];
}
    
@end
