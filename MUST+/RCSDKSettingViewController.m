//
//  RCSDKSettingViewController.m
//  MUSTPlus
//
//  Created by Cirno on 2017/8/26.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "RCSDKSettingViewController.h"
#import "AppDelegate.h"
#import "UserDetailsController.h"
@interface RCSDKSettingViewController ()

@end

@implementation RCSDKSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //显示顶部视图
    self.headerHidden = NO;
    [self inviteRemoteUsers:self.users];
//    //添加当前聊天用户
//    if (self.conversationType == ConversationType_PRIVATE) {
//        AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [delegate getUserInfoWithUserId:self.targetId completion:^(RCUserInfo *user) {
//            self.users = [[NSArray alloc]initWithObjects:user, nil];
//       
//        }];
//    } else {
//        AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [delegate getAllMembersOfGroup:self.targetId result:^(NSArray<NSString*>*result){
//            self.users = result;
//
//        }];
//    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didTipHeaderClicked:(NSString*)userId{
    UserDetailsController* udc = [[UserDetailsController alloc]init];
    udc.isSelf = NO;
    udc.naviGo = YES;
    udc.studID = userId;
    [self.navigationController pushViewController:udc animated:YES];
}

@end
