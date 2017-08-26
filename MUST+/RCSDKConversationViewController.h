//
//  RCSDKConversationViewController.h
//  MUSTPlus
//
//  Created by Cirno on 2017/8/17.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "UserDetailsController.h"
#import "RCSDKSettingViewController.h"
@interface RCSDKConversationViewController : RCConversationViewController
@property (nonatomic,strong) RCSDKSettingViewController *settingsVC;
@property (nonatomic,strong) NSArray* userid;
@property (nonatomic,strong) NSMutableArray* users;
@end
