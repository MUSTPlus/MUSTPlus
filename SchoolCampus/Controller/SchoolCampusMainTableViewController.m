//
//  SchoolCampusMainTableViewController.m
//  MUST_Plus
//
//  Created by zbc on 16/10/9.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "SchoolCampusMainTableViewController.h"
#import "GradeCoreDateManager.h"
//#import "CirnoSideBarViewController.h"
#import <SafariServices/SafariServices.h>
#import "SendMailTableViewController.h"
#import "BasicHead.h"
#import "ChangePinNumberView.h"
#import "SchoolBorrowBooksTableViewController.h"
#import "SearchGradeTableViewController.h"
#import "SchoolLibraryTableViewController.h"
#import "CourseViewController.h"
#import "SchoolFileController.h"
#import "UIImageView+WebCache.h"
#import "CurrencyViewController.h"
#import "SmartCampusViewController.h"
#import "BusStationViewController.h"
#import "Account.h"
#import "UserDetailsController.h"
#import "SettingViewController.h"
#import "GradeController.h"
#import "MessageController.h"
@interface SchoolCampusMainTableViewController ()<UIDocumentInteractionControllerDelegate>{
    ChangePinNumberView* cpnv;
}

@end

@implementation SchoolCampusMainTableViewController
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed =YES;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
//  CirnoLog(@"%@",self.navigationController);
    self.navigationController.navigationBar.backgroundColor = navigationTabColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor=navigationTabColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = NSLocalizedString(@"校园", "");
  //  [UINavigationBar appearance].tintColor = sidebarBackGroundColor;
    //tarbar遮挡问题用下面3行代码解决
    UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(-20.f, 0, CGRectGetHeight(self.tabBarController.tabBar.frame)-20, 0);
    self.tableView.contentInset = adjustForTabbarInsets;
    self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
    self.tableView.scrollEnabled =YES;
    UIBarButtonItem *sett = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sidebar_setting"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoSetting)];

    self.navigationItem.rightBarButtonItem = sett;
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开启滑动
    self.tabBarItem.title=NSLocalizedString(@"校园", "");
//    self.navigationController.navigationBar.hidden =NO;
//    self.navigationController.navigationBarHidden=NO;
    [self.tabBarController.tabBar setHidden:NO];

   // self.navigationController.navigationBarHidden=YES;
//    CirnoSideBarViewController * sideBar = [CirnoSideBarViewController share];
//    sideBar.diabled = true;
  //  [_head changeFace];
}
-(void)viewWillDisappear:(BOOL)animated{
   //  [self.tabBarController.tabBar setHidden:YES];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) return 30;
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) return 20;
    return 25;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==1){
        return 2;
    }
    else if(section == 2){
        return 4;
    }
    else if (section == 3){
        return 3;
    }
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"func" forIndexPath:indexPath];

    
    cell.imageView.image = [UIImage imageNamed:@"akarin"];
    if (indexPath.section == 0){
        _headerview = [[UIImageView alloc]initWithFrame:CGRectMake(16, 6, 65, 65)];
        _headerview.layer.cornerRadius = _headerview.frame.size.width/2;
        _headerview.clipsToBounds = YES;
        _headerview.layer.borderWidth = 2;
        _headerview.layer.borderColor = [UIColor clearColor].CGColor;
        NSURL *url = [NSURL URLWithString:[[Account shared]getAvatar]];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, Width-80, 80)];
        label.text =[[Account shared]getNickname];
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor blackColor];
        [_headerview sd_setImageWithURL:url];
        [cell addSubview:_headerview];
        [cell addSubview:label];
    }
    if(indexPath.section == 1){
        if(indexPath.row == 0){
            cell.textLabel.text = NSLocalizedString(@"查询图书", "");
            cell.imageView.image =[UIImage imageNamed:@"book"];
        }
        else if(indexPath.row == 1){
            cell.textLabel.text = NSLocalizedString(@"我的借书","");
            cell.imageView.image =[UIImage imageNamed:@"mybook"];
        }
        else if(indexPath.row == 2){
            cell.textLabel.text = NSLocalizedString(@"修改pin码","");
            cell.imageView.image =[UIImage imageNamed:@"password"];
        }

    }
    
    if(indexPath.section == 2){
        if(indexPath.row == 0){

            cell.textLabel.text = NSLocalizedString(@"成绩查询", "");
            cell.imageView.image =[UIImage imageNamed:@"grade"];
        }
        else if (indexPath.row == 1){
            cell.textLabel.text = NSLocalizedString(@"校园文件", "");
            cell.imageView.image =[UIImage imageNamed:@"calendar"];
        }
        else if (indexPath.row ==2){
            cell.textLabel.text = NSLocalizedString(@"课程", "");
            cell.imageView.image =[UIImage imageNamed:@"course"];
        } else if (indexPath.row ==3){
            cell.textLabel.text = NSLocalizedString(@"学生邮箱", "");
            cell.imageView.image = [UIImage imageNamed:@"mail-1"];
        }
    }
    if (indexPath.section == 3){
        if (indexPath.row == 0){
            cell.textLabel.text = NSLocalizedString(@"公交车", "");
            cell.imageView.image =[UIImage imageNamed:@"bus"];
        } else if (indexPath.row == 1){
            cell.textLabel.text = NSLocalizedString(@"汇率", "");
            cell.imageView.image =[UIImage imageNamed:@"currency-1"];
        } else if (indexPath.row == 2){
            cell.textLabel.text = NSLocalizedString(@"智慧校园", "");
            cell.imageView.image =[UIImage imageNamed:@"connection"];
        }
    }
    CGSize itemSize = CGSizeMake(30, 30);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return 80;
    return 44;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if (section == 1) {
        return NSLocalizedString(@"图书馆", "");
    }
    else if (section == 2)
        return NSLocalizedString(@"课业", "");
    else if (section == 3)
        return NSLocalizedString(@"生活", "");
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    //取消选中

    switch (section){
        case 0:
        {
            [self gotoSelf];
            break;
        }
        case 1:
            switch (row){
                case 0:{
                    NSString* str = @"http://lib.must.edu.mo/m/index.html#mylibrarylogin";
                    SFSafariViewController* sf = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:str]];
                    [self.tabBarController.tabBar setHidden:YES];
                    [self.navigationController pushViewController:sf animated:YES];

                    }
                    break;
                case 1:{
                    NSString* str = @"http://search.ebscohost.com/login.aspx?direct=true&site=eds-live&scope=site&type=0&custid=ns002233&groupid=main&profid=edsopac&mode=and&authtype=ip,guest&lang=zh-tw";
                    [self.tabBarController.tabBar setHidden:YES];
                    SFSafariViewController * sf = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:str]];

                    [self.navigationController pushViewController:sf animated:YES];
                    }
                    break;
//                case 2:{
//                    cpnv=[[ChangePinNumberView alloc] init];
//                    [cpnv show];
//                    break;
//                }
            }
            break;
        case 2:
            switch (row){
                case 0:{//成绩
                    [self authforgrade];

                }
                    break;
                case 1://校历
                    [self showCal];
                    break;
                case 2://假期
                    [self showCourse];
                    break;
                case 3:
                    [self jumpToMail];
                    break;
            }
            break;
        case 3:
            switch (row) {
                case 0:
                    [self jumpToBus];
                    break;
                case 1:
                    [self jumpToCurrency];
                    break;
                case 2:
                    [self jumpToSmartCampus];
                    break;
                default:
                    break;
            }

    }
}
-(void)showCourse{
    CourseViewController * cvc = [[CourseViewController alloc]init];
    [self.navigationController pushViewController:cvc animated:YES];

}
-(void)viewPdf:(NSString*)filename{
    UIDocumentInteractionController *documentController = [UIDocumentInteractionController interactionControllerWithURL:[[NSBundle mainBundle] URLForResource:filename withExtension:@"pdf"]];
    [documentController setDelegate:self];
    [UINavigationBar appearance].barTintColor = navigationTabColor;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [documentController presentPreviewAnimated:YES];
}


-(void)showCal{
   // MessageController* ctr = [[MessageController alloc]init];
    SchoolFileController *ctr = [[SchoolFileController alloc]init];
    ctr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctr animated:YES];
}
-(void)jumpToBus{
    BusStationViewController *ctr = [[BusStationViewController alloc] init];
  //  ctr.showDoneButton = 0;
    ctr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:ctr];
    [self presentViewController:passcodeNavigationController animated:YES completion:nil];
}
-(void)jumpToMail{
    SendMailTableViewController *ctr = [[SendMailTableViewController alloc] init];
    ctr.dontShowDone = 1;
    [self.navigationController pushViewController:ctr animated:YES];
}
-(void)jumpToSmartCampus{
    SmartCampusViewController * ctr = [[SmartCampusViewController alloc]init];
    [self.navigationController pushViewController:ctr animated:YES];

}
-(void)jumpToCurrency{
    CurrencyViewController * ctr = [[CurrencyViewController alloc]init];
    ctr.dontShowBack = 1;
    
    [self.navigationController pushViewController:ctr animated:YES];
}
-(void)gotoSelf{
    UserDetailsController* udc = [[UserDetailsController alloc]init];
    udc.studID=[[Account shared]getStudentLongID];
    udc.isSelf = YES;
    udc.naviGo = YES;
    [self.navigationController pushViewController:udc animated:YES];
}
-(void)gotoSetting{
    SettingViewController *ctr = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:ctr animated:YES];
}
-(void)authforgrade{

        //初始化上下文对象
        LAContext* context = [[LAContext alloc] init];
        //错误对象
        NSError* error = nil;
        NSString* result = NSLocalizedString(@"查看成绩指纹", "");

        //首先使用canEvaluatePolicy 判断设备支持状态
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            //支持指纹验证
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
                if (success) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        //用户选择输入密码，切换主线程处理
                        [self gotogradevc];

                    }];

                    //验证成功，主线程处理UI
                }
                else
                {
                    [CirnoError ShowErrorWithText:NSLocalizedString(@"指纹其他错误", "")];
                    NSLog(@"%@",error.localizedDescription);
                    switch (error.code) {
                        case LAErrorSystemCancel:
                        {
                            NSLog(@"Authentication was cancelled by the system");
                            //切换到其他APP，系统取消验证Touch ID
                            break;
                        }
                        case LAErrorUserCancel:
                        {
                            NSLog(@"Authentication was cancelled by the user");
                            //用户取消验证Touch ID
                            break;
                        }
                        case LAErrorUserFallback:
                        {
                            NSLog(@"User selected to enter custom password");
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                //用户选择输入密码，切换主线程处理
                                [self EnterStuPassWord];
                            }];
                            break;
                        }
                        default:
                        {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                //其他情况，切换主线程处理
                            }];
                            break;
                        }
                    }
                }
            }];
        }
        else
        {
            //不支持指纹识别，LOG出错误详情
            //[CirnoError ShowErrorWithText:error.localizedDescription];
            [self EnterStuPassWord];
            switch (error.code) {
                case LAErrorTouchIDNotEnrolled:
                {
                    NSLog(@"TouchID is not enrolled");
                    break;
                }
                case LAErrorPasscodeNotSet:
                {
                    NSLog(@"A passcode has not been set");
                    break;
                }
                default:
                {
                    NSLog(@"TouchID not available");
                    break;
                }
            }
            NSLog(@"%@",error.localizedDescription);
        }
}
-(void)gotogradevc{
    GradeController *next = [[GradeController alloc] init];
    [self.navigationController pushViewController:next animated:YES];
}
-(void)EnterStuPassWord{
    Alert *alert = [[Alert alloc] initWithTitle:NSLocalizedString(@"输入学生账号密码","") message:nil
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"取消","")
                              otherButtonTitles:NSLocalizedString(@"确定",""), nil];
    alert.alertStyle = AlertStyleSecureTextInput;
    __block Alert*alertV = alert;
    [alert setClickBlock:^(Alert *alertView, NSInteger buttonIndex) {
        NSLog(@"%@", alertV.textField.text);
        NSLog(@"%ld",(long)buttonIndex);

        if (buttonIndex == 1) {
            NSString* pw = [[Account shared] getPassword];
            if ([alertV.textField.text isEqualToString:pw]){
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    SearchGradeTableViewController *next = [[SearchGradeTableViewController alloc] init];
                    [self.navigationController pushViewController:next animated:YES];
                }];
            } else {
                [CirnoError ShowErrorWithText:NSLocalizedString(@"验证失败", "")];
            }

        }
    }];
    [alert setCancelBlock:^(Alert *alertView) {
        // 取消
    }];
    [alert show];
}
@end
