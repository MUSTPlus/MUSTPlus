//
//  SchoolCampusMainTableViewController.m
//  MUST_Plus
//
//  Created by zbc on 16/10/9.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "SchoolCampusMainTableViewController.h"
#import "GradeCoreDateManager.h"
#import "CirnoSideBarViewController.h"
#import "BasicHead.h"
#import "ChangePinNumberView.h"
#import "SchoolBorrowBooksTableViewController.h"
#import "SearchGradeTableViewController.h"
#import "SchoolLibraryTableViewController.h"
#import "CourseViewController.h"
#import "SchoolFileController.h"
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
    self.tableView.scrollEnabled =NO;
//    
//    _head = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, StatusBarAndNavigationBarHeight)];
//    [_head drawHeadViewWithTtile:NSLocalizedString(@"校园", "") buttonImage:nil];
//    self.tableView.tableHeaderView = _head;

    self.tableView.bounces = false;
    
    //注册键盘出现的通
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开启滑动
    self.tabBarItem.title=NSLocalizedString(@"校园", "");
    self.navigationController.navigationBar.hidden =NO;
    self.navigationController.navigationBarHidden=NO;
   // self.navigationController.navigationBarHidden=YES;
    CirnoSideBarViewController * sideBar = [CirnoSideBarViewController share];
    sideBar.diabled = true;
  //  [_head changeFace];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) return 30;
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return 3;
    }
    else if(section == 1){
        return 3;
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"func" forIndexPath:indexPath];

    
    cell.imageView.image = [UIImage imageNamed:@"Touch"];
    
    if(indexPath.section == 0){
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
    
    if(indexPath.section == 1){
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"图书馆", "");
    }
    else
        return NSLocalizedString(@"课业", "");
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    //取消选中

    switch (section){
        case 0:
            switch (row){
                case 0:{
                    SchoolLibraryTableViewController  *next = [[SchoolLibraryTableViewController alloc] init];
                    [self.navigationController pushViewController:next animated:YES];

                    }
                    break;
                case 1:{
                    SchoolBorrowBooksTableViewController *next = [[SchoolBorrowBooksTableViewController alloc] init];
                    [self.navigationController pushViewController:next animated:YES];
                    }
                    break;
                case 2:{
                    cpnv=[[ChangePinNumberView alloc] init];
                    [cpnv show];
                    break;
                }
            }
            break;
        case 1:
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

                    break;
            }
            break;

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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [JPUSHService stopLogPageView:@"校园页"];
}
-(void)showCal{
    SchoolFileController *ctr = [[SchoolFileController alloc]init];
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
    SearchGradeTableViewController *next = [[SearchGradeTableViewController alloc] init];
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
