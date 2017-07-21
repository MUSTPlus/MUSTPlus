//
//  UserModel.m
//  MUST_Plus
//
//  Created by Cirno on 16/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//
#import "CirnoError.h"
#import "UserModel.h"
#import "HeiHei.h"
#import <AFNetworking.h>
#import "NSString+AES.h"
#import "BasicHead.h"
#import "Alert.h"
#import "Account.h"
@implementation UserModel
-(void) initWithNickname:(NSString*)nickname
            andAvatarURL:(NSString*)avatarpicurl
            andGradeType:(GradeType)gradetype
            andMajorType:(MajorType)majortype{
    _nickname     = nickname;
    _avatarPicURL = avatarpicurl;
    _grade        = gradetype;
    _major        = majortype;
}
-(UserModel*)getUserModel2:(NSString*)studentID{
    UserModel* usrModel = [[UserModel alloc]init];
    NSDictionary *o1 =@{@"ec":@"1032",
                        @"studentID": studentID};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    NSDictionary *parameters = @{@"ec":data};
    NSURL *URL = [NSURL URLWithString:BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    Alert *alert = [[Alert alloc]initWithTitle:NSLocalizedString(@"错误", "")
                                       message:NSLocalizedString(@"网络错误", "")
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"好", "")
                             otherButtonTitles:nil,
                    nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
        [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];

            NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if([json[@"state"] isEqualToString:@"1"]){
                @try {
                    NSDictionary *newjson = json[@"info"];
                    usrModel.studentID    = [newjson objectForKey:@"studentID"];
                    usrModel.avatarPicURL = [newjson objectForKey:@"face"] ;
                    usrModel.bgURL        = [newjson objectForKey:@"backgroundimage"] ;
                    usrModel.grade        = [newjson objectForKey:@"GradeType"] ;
                    usrModel.major        = [newjson objectForKey:@"MajorType"] ;
                    usrModel.whatsup      = [newjson objectForKey:@"signText"] ;
                    usrModel.nickname     = [newjson objectForKey:@"nickName"] ;
                    usrModel.isVip        = [[newjson objectForKey:@"isVip"]integerValue];
                    usrModel.program      = [newjson objectForKey:@"Program"];
                    usrModel.faculty      = [newjson objectForKey:@"Faculty"];
                    usrModel.gender       = [newjson objectForKey:@"Gender"];
                    if (usrModel.isVip == 2) usrModel.verifiedtype = kVerifiedTypeAdministrator;
                    usrModel.verifiedtype = (usrModel.isVip == 1)? kVerifiedTypeNone:kVerifiedTypeVIP;

                } @catch (NSException *exception) {
                    [CirnoError ShowErrorWithText:exception.description];
                } @finally {

                }

            }
            else{
                [alert show];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [CirnoError ShowErrorWithText:[error localizedDescription]];
            [alert show];
        }];
        // 耗时的操作
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
        });  
    });

    return usrModel;

}
-(UserModel*)getUserModel:(NSString *)studentID{
    __block BOOL isFin = NO;
    UserModel* usrModel = [[UserModel alloc]init];
    NSDictionary *o1 =@{@"ec":@"1032",
                        @"studentID": studentID};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    NSDictionary *parameters = @{@"ec":data};
    NSURL *URL = [NSURL URLWithString:BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    Alert *alert = [[Alert alloc]initWithTitle:NSLocalizedString(@"错误", "")
                                       message:NSLocalizedString(@"网络错误", "")
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"好", "")
                             otherButtonTitles:nil,
                    nil];

    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];

        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if([json[@"state"] isEqualToString:@"1"]){
            @try {
                NSDictionary *newjson = json[@"info"];
                usrModel.studentID    = [newjson objectForKey:@"studentID"];
                usrModel.avatarPicURL = [newjson objectForKey:@"face"] ;
                usrModel.bgURL        = [newjson objectForKey:@"backgroundimage"] ;
                usrModel.grade        = [newjson objectForKey:@"GradeType"] ;
                usrModel.major        = [newjson objectForKey:@"MajorType"] ;
                usrModel.whatsup      = [newjson objectForKey:@"signText"] ;
                usrModel.nickname     = [newjson objectForKey:@"nickName"] ;
                usrModel.isVip        = [[newjson objectForKey:@"isVip"]integerValue];
                usrModel.program      = [newjson objectForKey:@"Program"];
                usrModel.faculty      = [newjson objectForKey:@"Faculty"];
                usrModel.gender       = [newjson objectForKey:@"Gender"];
                if (usrModel.isVip == 2) usrModel.verifiedtype = kVerifiedTypeAdministrator;
                NSInteger p = 1;

                usrModel.verifiedtype = (usrModel.isVip == p)? kVerifiedTypeNone:kVerifiedTypeVIP;
                isFin=YES;
            } @catch (NSException *exception) {
                 [CirnoError ShowErrorWithText:exception.description];
            } @finally {

            }

        }
        else{
            [alert show];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];
        [alert show];
    }];

    @try {
        while (!isFin){
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0f]];
        }
    } @catch (NSException *exception) {
        [CirnoError ShowErrorWithText:exception.description];
    } @finally {
        
    }
    if (_test){
        [[Account shared]setWhatsup:usrModel.whatsup];
        [[Account shared]setNickname:usrModel.nickname];
        [[Account shared]setAvatar:usrModel.avatarPicURL];
        [[Account shared]setProgram:usrModel.program];
        [[Account shared]setFaculty:usrModel.faculty];
    }
    return usrModel;
}
@end
