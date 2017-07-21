//
//  AliDataManagement.m
//  MUST_Plus
//
//  Created by zbc on 16/11/19.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "AliDataManagement.h"
#import <AliyunOSSiOS/OSSService.h>
#import "Account.h"
@implementation AliDataManagement{
    OSSClient *client;
    int count;
    NSMutableArray *nameArray;
}

-(id)init{
    self = [super init];
    [self initAli];
    _pucNum = 0;
    count = 0;
    nameArray = [[NSMutableArray alloc] init];
    return self;
}


-(void) initAli{
    NSString *endpoint = @"https://oss-cn-shanghai.aliyuncs.com";
  //  https://mustplus.oss-cn-shanghai.aliyuncs.com/
    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式请参考后面的`访问控制`章节
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"PUOqADxdBsEj9dGp"
                                                                                                            secretKey:@"CBxqfr2KjT8EzzfpsgP5R9nQ8Er3ZQ"];

    client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
}


-(void) uploadImg:(NSData *)data
            name :(int)name{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd:MM:YY:HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"%@",dateString);
    
    //根据 1309853zi011001:19/11/16/12/14/31（1，2，3，4）保证唯一性
    
    NSString * uploadObjectkey = [NSString stringWithFormat:@"%@:%@:%d.jpg",[[Account shared] getStudentShortID],dateString,name];
    
    put.bucketName = @"mustplus";
    put.objectKey = uploadObjectkey;
    
    [nameArray addObject:uploadObjectkey];
    
    put.uploadingData = data; // 直接上传NSData
    
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            [self checkAllUpdate];
            NSLog(@"upload object success!");
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}
//上传头像
-(void) uploadAvatar:(NSData *)data
            name :(int)name{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd:MM:YY:HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"%@",dateString);
    
    //根据 1309853zi011001:19/11/16/12/14/31（1，2，3，4）保证唯一性
    
    NSString * uploadObjectkey = [NSString stringWithFormat:@"%@:%@:%d-Avatar.jpg",[[Account shared] getStudentShortID],dateString,name];
    
    put.bucketName = @"mustplus";
    put.objectKey = uploadObjectkey;
    
    [nameArray addObject:uploadObjectkey];
    
    put.uploadingData = data; // 直接上传NSData
    
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            [self checkAllUpdate];
            NSLog(@"upload object success!");
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}

//上传背景
-(void) uploadBGImage:(NSData *)data
               name :(int)name{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd:MM:YY:HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"%@",dateString);
    
    //根据 1309853zi011001:19/11/16/12/14/31（1，2，3，4）保证唯一性
    
    NSString * uploadObjectkey = [NSString stringWithFormat:@"%@:%@:%d-BG.jpg",[[Account shared] getStudentShortID],dateString,name];
    
    put.bucketName = @"mustplus";
    put.objectKey = uploadObjectkey;
    
    [nameArray addObject:uploadObjectkey];
    
    put.uploadingData = data; // 直接上传NSData
    
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            [self checkAllUpdate];
            NSLog(@"upload object success!");
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}

-(void) checkAllUpdate{
    count++;
    if(_pucNum == count){
        [_uploadSuccessDelegate uploadSuccess:nameArray];
    }
}


@end
