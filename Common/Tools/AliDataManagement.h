//
//  AliDataManagement.h
//  MUST_Plus
//
//  Created by zbc on 16/11/19.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UploadSuccessDelegate
-(void)uploadSuccess:(NSMutableArray *)nameArray;
@end

@interface AliDataManagement : NSObject


@property (nonatomic) int pucNum;

-(void) uploadImg:(NSData *)data
            name :(int)name;
-(void) uploadAvatar:(NSData *)data
            name :(int)name;
@property(assign,nonatomic) id<UploadSuccessDelegate> uploadSuccessDelegate;

-(void) uploadBGImage:(NSData *)data
                name :(int)name;
@end
