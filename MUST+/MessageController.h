//
//  MessageController.h
//  
//
//  Created by Cirno on 2017/8/6.
//
//

#import <UIKit/UIKit.h>
#import "BasicHead.h"
#import <RongIMKit/RongIMKit.h>
#import "RCSDKConversationViewController.h"
#import "BasicHead.h"
#import "AFNetworking.h"
#import "Account.h"
#import "CirnoError.h"
#import "RCSDKConverstionListViewController.h"
@interface MessageController : RCSDKConverstionListViewController

@property (nonatomic,strong) NSString* token;
@end
