//
//  SettingViewController.m
//  MUST_Plus
//
//  Created by Cirno on 11/12/2016.
//  Copyright © 2016 zbc. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#import "SettingViewController.h"
#import "UIImageView+WebCache.h"
#import "UserDetailCellTableViewCell.h"
#import "BasicHead.h"
#import "CirnoError.h"
#import <MessageUI/MessageUI.h>
#import "Account.h"
#import "LoginViewController.h"
#import "LogoutLogic.h"
#import "MyMessageCircleViewController.h"
#import "AboutViewController.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UIImageView *headerview;
@property (nonatomic,strong) UIView* navibar;
@property (nonatomic,strong) UIButton* backbutton;
@property (nonatomic,strong) UILabel* information;
@end

@implementation SettingViewController
- (void)viewDidLoad {
    self.navigationController.navigationBar.hidden =NO;
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = navigationTabColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor=navigationTabColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title =NSLocalizedString(@"设置", "");
  //  [_backbutton setImage:[UIImage imageNamed:@"story_back" ]forState:UIControlStateNormal];
  //  [_backbutton setImage:[UIImage imageNamed:@"story_back_pres"] forState:UIControlStateSelected];
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableview];

    _tableview.delegate =self;
    _tableview.dataSource = self;
   // [self.view addSubview:_navibar];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    //取消选中
    if  (section == 1){
        if (row == 0){
            [self ClickAvatar];
        }
    } else {
        if (row == 0){
            [self ClickAbout];
        }
        if (row == 1){
            [self sendEmail];
        }
        if (row ==2){
            [self ClickNotificationStatus];
        }
    }

}
-(void) ClickAbout{
    AboutViewController * avc = [[AboutViewController alloc]init];
    [self.navigationController pushViewController:avc animated:YES];
}
-(void) ClickAvatar{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"当前用户", "") message:[[Account shared]getStudentLongID] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", "") style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"退出登录", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self logout];
    }];

    [alertController addAction:cancelAction];

    [alertController addAction:logoutAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}


-(void) logout{
    [JPUSHService setTags:[NSSet set]callbackSelector:nil object:self];
    [JPUSHService setAlias:@"" callbackSelector:nil object:self];
    [JPUSHService setTags:[NSSet set] alias:@"" callbackSelector:nil target:self];
    LoginViewController *a = [[LoginViewController alloc] init];
    [LogoutLogic deleteALL];
    [self presentViewController:a animated:false completion:nil];
}
-(void)ClickNotificationStatus{

    NSInteger status = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
    NSLog(@"status = %ld",(long)status);
    if (status == 0){
        NSString * identifier = [NSBundle mainBundle].bundleIdentifier;
        NSString * str = [NSString stringWithFormat:@"App-Prefs:root=NOTIFICATIONS_ID&path=%@",identifier];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//        NSString * mess = [[NSString alloc]initWithFormat:@"%@ %@",NSLocalizedString(@"推送状态", ""),NSLocalizedString(@"关闭", "")];
//        Alert * alert = [[Alert alloc]initWithTitle:NSLocalizedString(@"推送状态", "")
//                                            message:mess
//                                           delegate:nil
//                                  cancelButtonTitle:NSLocalizedString(@"好", "")
//                                  otherButtonTitles: nil ];
//        [alert show];
//        NSLocalizedString(@"推送状态", "");
        return;
    }
    NSString *GradeType = [[[Account shared]getGradeType] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *MajorType = [self replaceUnicode:[[Account shared]getMajorType]];
    NSString *vip = [NSString stringWithFormat:@"vip%@",[[Account shared]getVip]];
    NSSet* tags = [NSSet alloc];
    tags = [NSSet setWithObjects:GradeType,MajorType,vip,nil];
    NSString *alia =  [[Account shared] getStudentShortID] ;

    [JPUSHService setTags:tags alias:alia fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSString* vip = [NSString stringWithFormat:@"%@",[[Account shared]getVip]];
        if (![vip isEqualToString:@"1"]){
            NSString *mess =[[NSString alloc]initWithFormat:@"返回代码%d,tags%@,别名%@",iResCode,tags,iAlias];
            Alert * alert = [[Alert alloc]initWithTitle:NSLocalizedString(@"推送状态", "")
                                                message:mess
                                               delegate:nil
                                      cancelButtonTitle:NSLocalizedString(@"好", "")
                                      otherButtonTitles: nil ];
            [alert show];
        } else {
            if (iResCode==0){

                NSString *mess =[[NSString alloc]initWithFormat:NSLocalizedString(@"注册成功", "")];
                Alert * alert = [[Alert alloc]initWithTitle:NSLocalizedString(@"推送状态", "")
                                                    message:mess
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"好", "")
                                          otherButtonTitles: nil ];
                [alert show];
            } else {
                NSString *mess =[[NSString alloc]initWithFormat:@"%@%d",NSLocalizedString(@"注册失败", ""),iResCode];
                Alert * alert = [[Alert alloc]initWithTitle:NSLocalizedString(@"推送状态", "")
                                                    message:mess
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"好", "")
                                          otherButtonTitles: nil ];
                [alert show];
            }

        }
    }];

}
- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    NSLog(@"return str%@",[returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"]);
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}
-(void)ClickMyCircie{
    MyMessageCircleViewController *a = [[MyMessageCircleViewController alloc] init];
    a.studentID=[Account shared].getStudentLongID ;
    [self.navigationController pushViewController:a animated:YES];
}
- (void)sendEmail {
    // Email Subject
    NSString *emailTitle = @"";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@must.plus"];

    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    if (MFMailComposeViewController.canSendMail)
        [self presentViewController:mc animated:YES completion:NULL];
    else
        [self launchMailAppOnDevice];
}
-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:support@must.plus";
    NSString *body = @"";
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];

    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        NSLog(@"Result : %ld",(long)result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    NSInteger row = indexPath.row;
    CirnoLog(@"%ld,%ld",indexPath.section,indexPath.row);
    if (indexPath.section == 1){
        UITableViewCell*cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = @"退出当前账号";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    } else{
        UserDetailCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            cell = [[UserDetailCellTableViewCell alloc]init];
        }

    switch (row){
        case 0:
            {
                cell = [[UserDetailCellTableViewCell alloc]initWithFrame:CGRectMake(0, 0, Width, 50) andIcon:[UIImage imageNamed:@"ClassIcon"]];
                cell.textLabel.text=NSLocalizedString(@"关于", "");

            }
            break;
        case 1:
            cell = [[UserDetailCellTableViewCell alloc]initWithFrame:CGRectMake(0, 0, Width, 50) andIcon:[UIImage imageNamed:@"mail"]];
            cell.textLabel.text=NSLocalizedString(@"联系我们", "");
            break;
        case 2:{
            cell = [[UserDetailCellTableViewCell alloc]initWithFrame:CGRectMake(0, 0, Width, 50) andIcon:[UIImage imageNamed:@"notification"]];
            NSInteger status = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
            cell.textLabel.text=NSLocalizedString(@"推送状态", "");
            UILabel* detailtext = [[UILabel alloc]initWithFrame:CGRectMake(Width-80, 0, 70, 50)];
            detailtext.textAlignment = NSTextAlignmentCenter;
            detailtext.textColor = [UIColor grayColor];
            detailtext.text = status?NSLocalizedString(@"开启", ""):NSLocalizedString(@"关闭","");
            [cell addSubview:detailtext];
            break;
        }
        case 3:
            cell = [[UserDetailCellTableViewCell alloc]initWithFrame:CGRectMake(0, 0, Width, 50) andIcon:[UIImage imageNamed:@"radar"]];
            NSInteger status = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
            cell.textLabel.text=NSLocalizedString(@"找回我的学生卡", "");
            UISwitch *switchView = [[UISwitch alloc] init];
            [switchView setOn:status];
            switchView.userInteractionEnabled =NO;
            switchView.enabled =NO;
            cell.accessoryView = switchView;
            cell.userInteractionEnabled = NO;
            break;

        }
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section ==0){
        return NSLocalizedString(@"找回我的学生卡说明", "");
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1)
        return 1;
    else return 4;
}

@end
#pragma clang diagnostic pop
