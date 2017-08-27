//
//  RCSDKConversationViewController.m
//  MUSTPlus
//
//  Created by Cirno on 2017/8/17.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "RCSDKConversationViewController.h"
#import "RCDUIBarButtonItem.h"
#import "Account.h"
#import "AppDelegate.h"
@interface RCSDKConversationViewController ()

@end

@implementation RCSDKConversationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.enableUnreadMessageIcon = YES;
    self.enableNewComingMessageIcon = YES;
    if (self.conversationType == ConversationType_GROUP) {
        [self setRightNavigationItem:[UIImage imageNamed:@"Group_Setting"]
                           withFrame:CGRectMake(10, 3.5, 21, 19.5)];
    } else {
        [self setRightNavigationItem:[UIImage imageNamed:@"Private_Setting"]
                           withFrame:CGRectMake(15, 3.5, 16, 18.5)];
    }
    _settingsVC = [[RCSDKSettingViewController alloc]init];
    _settingsVC.targetId = self.targetId;
    _settingsVC.conversationType = self.conversationType;
    _settingsVC.headerHidden = NO;
    __weak RCSDKConversationViewController *weakSelf = self;
    _settingsVC.clearHistoryCompletion = ^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.conversationDataRepository removeAllObjects];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.conversationMessageCollectionView reloadData];
            });
        }
    };
    self.userid = [[NSArray alloc]init];
    if (self.conversationType == ConversationType_PRIVATE) {
        AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate getUserInfoWithUserId:self.targetId completion:^(RCUserInfo *user) {
            _settingsVC.users = [[NSArray alloc]initWithObjects:user, nil];
        }];
    } else {
        AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate getAllMembersOfGroup:self.targetId result:^(NSArray<NSString*>*result){
            _userid = result;
            [self update];
        }];
    }
    // Do any additional setup after loading the view.
}
-(void)update{
    self.users = [[NSMutableArray alloc]init];
     AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (NSString* str in self.userid)
        [delegate getUserInfoWithUserId:str completion:^(RCUserInfo* userinfo){
            if (userinfo!=NULL)
                [self.users addObject:userinfo];
    }];
    _settingsVC.users =self.users;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(RCMessage*)willAppendAndDisplayMessage:(RCMessage *)message{

    if ((message.content.class == [RCInformationNotificationMessage class])&&
        [message.senderUserId isEqualToString:@"GROUPADMIN"]){
        return nil;
    }
    [super willAppendAndDisplayMessage:message];
    
    //if (message.content)
    return message;
}
-(void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)didTapCellPortrait:(NSString *)userId{
    [super didTapCellPortrait:userId];
    UserDetailsController* udc = [[UserDetailsController alloc]init];
    udc.isSelf = NO;
    udc.studID = userId;
    udc.naviGo = YES;
    [self.navigationController pushViewController:udc animated:YES];
}
- (void)setRightNavigationItem:(UIImage *)image withFrame:(CGRect)frame {
    RCDUIBarButtonItem *rightBtn = [[RCDUIBarButtonItem alloc]
                                    initContainImage:image
                                    imageViewFrame:frame
                                    buttonTitle:nil
                                    titleColor:nil
                                    titleFrame:CGRectZero
                                    buttonFrame:CGRectMake(0, 0, 25, 25)
                                    target:self
                                    action:@selector(rightBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)rightBarButtonItemClicked:(id)sender {

    [self.navigationController pushViewController:_settingsVC animated:YES];





}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
@end
