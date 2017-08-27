//
//  SystemNotification.h
//  MUSTPlus
//
//  Created by Cirno on 2017/8/26.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import <RongIMLib/RCMessageContentView.h>
#define RCLocalMessageTypeIdentifier @"RC:SystemMsg"
@interface SystemNotification : RCMessageContent<NSCoding,RCMessageContentView>
//@property(nonatomic,strong)
@property(nonatomic, strong) NSString* content;

@end
