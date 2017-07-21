//
//  LikeCommentShareLogic.m
//  MUST_Plus
//
//  Created by zbc on 16/11/22.
//  Copyright © 2016年 zbc. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
#import "LikeCommentShareLogic.h"
#import "NSString+AES.h"
#import "HeiHei.h"
#import <AFNetworking.h>
#import "Account.h"
#import "CirnoError.h"
@implementation LikeCommentShareLogic


+(void)like:(long long)ID{
    
    //数据流加密
    NSDictionary *o1 =@{@"ec":@"1024",
                        @"messageID":[NSString stringWithFormat:@"%lld",ID],
                        @"studentID": [[Account shared]getStudentLongID]};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    
    NSLog(@"%@",[data AES256_Decrypt:[HeiHei toeknNew_key]]);
    NSLog(@"%@",data);
    
    
    //POST数据
    NSDictionary *parameters = @{@"ec":data};
    
    NSURL *URL = [NSURL URLWithString:BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //转成最原始的data,一定要加
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
        
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
     //   id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        //处理json
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];
        // [alert show];
     
    }];


}



+(void)comment:(long long)messageID
messageContext:(NSString *)context{
    
    //数据流加密
    NSDictionary *o1 =@{@"ec":@"1022",
                        @"messageID":[NSString stringWithFormat:@"%lld",messageID],
                        @"studentID": [[Account shared]getStudentLongID],
                        @"isReplyComment":@"0",
                        @"messageContext":context,
                        @"ReplyCommentID" : @"0"};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    
    NSLog(@"%@",[data AES256_Decrypt:[HeiHei toeknNew_key]]);
    NSLog(@"%@",data);
    
    
    //POST数据
    NSDictionary *parameters = @{@"ec":data};
    
    NSURL *URL = [NSURL URLWithString:BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //转成最原始的data,一定要加
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
        
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
     //   id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        //处理json
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];
        // [alert show];
        
    }];
}


@end
#pragma clang diagnostic pop
