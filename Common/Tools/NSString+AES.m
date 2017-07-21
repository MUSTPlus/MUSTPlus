//
//  NSString+AES.m
//  AES_256
//
//  Created by Mac Mini 10.10 on 16/3/30.
//  Copyright © 2016年 Bison. All rights reserved.
//

#import "NSString+AES.h"

@implementation NSString (AES)

    
    
    
/*
 用法
 NSString *key = @"12345678";
 
 NSString *secret = @"aes Bison base64";
 
 NSLog(@"字符串加密---%@",[secret AES256_Encrypt:key]);
 
 //字符串解密
 NSLog(@"字符串解密---%@",[[secret AES256_Encrypt:key] AES256_Decrypt:key]);
 */
   
//加密
- (NSString *) AES256_Encrypt:(NSString *)key{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    
//    NSLog(@"%d compare %d",[self convertToInt:self],(int)self.length);

    NSData *data = [NSData dataWithBytes:cstr length:[self convertToInt:self]];
    
    //对数据进行加密
    NSData *result = [data AES256_Encrypt:key];
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        
        Byte *datas = (Byte*)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        return output;
    }
    return nil;
}

- (int)convertToInt:(NSString*)strtemp//判断中英混合的的字符串长度
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUTF8StringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUTF8StringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

//解密
- (NSString *) AES256_Decrypt:(NSString *)key{
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    NSData* result = [data AES256_Decrypt:key];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end
