//
//  MessageCircleController.m
//  MUST_Plus
//
//  Created by Cirno on 05/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "MessageCircleController.h"
#import "BasicHead.h"
#import "ComposeViewController.h"
#import "NSString+AES.h"
#import "HeiHei.h"
#import <AFNetworking.h>
#import "receivceMessageLogic.h"
#import "JDStatusBarNotification.h"
#import "CirnoError.h"
//#import "CirnoSideBarViewController.h"
#import "UserDetailsController.h"
#import "CirnoError.h"
#import "Account.h"
#import "MTA.h"
@interface MessageCircleController ()<UserDetailsDelegate>{
    NSMutableArray *_statusFrames;
    long long lastID; //此ID非彼ID那么就删了吧
}
@property (nonatomic,strong) UIImageView* sentimg;
@property (nonatomic,strong) StatusCell* tcell;
//@property (nonatomic,strong) BaseStatusCellFrame* frame;//公用frame会出错

@end

@implementation MessageCircleController
-(void)ClickAvatar:(id)button{
    UIButton * k = button;
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wformat"
    NSString * zxczxc = [NSString stringWithFormat:@"%@",k.tag];
    #pragma clang diagnostic pop
    UserDetailsController* udc = [[UserDetailsController alloc]init];
    udc.isSelf = NO;
     udc.studID = zxczxc;
    //udc.currentUser = [[UserModel alloc]getUserModel:zxczxc];
    [self.navigationController pushViewController:udc animated:YES];
}

-(void)Avatar{
    UserDetailsController* udc = [[UserDetailsController alloc]init];
    udc.studID=[[Account shared]getStudentLongID];
    udc.isSelf = YES;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:udc];

    // navi.navigationBarHidden = YES;
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title = NSLocalizedString(@"完成", "");
    navi.navigationItem.backBarButtonItem=backbutton;
    //[self pushViewController:udc animated:YES];
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = sidebarBackGroundColor;
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    [self presentViewController:navi animated:YES completion:nil];
}
-(void)ClickAdd:(id)button{
    MessageSendViewController *controller = [[MessageSendViewController alloc] init];
    controller.pushSuccessDelegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:passcodeNavigationController animated:YES completion:nil];
}

#pragma mark - 这里是send成功的delegate方法
-(void)pushMessageSuccess{
    [self showWhenUpdateSuccess];
    [self pullDownAction];
}


-(void)viewWillDisappear:(BOOL)animated{
    NSString* page = @"MessageCircle";
    [MTA trackPageViewEnd:page];
}
-(void)pushMessageFail{
    [self showWhenUpdateFail];
}

-(void)showWhenUpdateSuccess{
    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"发送成功", "") dismissAfter:2];

}

-(void)showWhenUpdateFail{
    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"发送失败", "")dismissAfter:2];
}


#pragma mark - 结束
- (void)viewDidLoad {

    [super viewDidLoad];
    
    // 1.标题
    _msgHeadView = [[MessageHeadView alloc] initWithFrame:CGRectMake(0, 0, Width, StatusBarAndNavigationBarHeight)];
    _msgHeadView.messageHeadAddButtonDelegate = self;
    [self.view addSubview:_msgHeadView];
    
    // 2.TableView的初始化
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, Width, Height-NavigationBarHeight)];
    _tableView.delegate = self;
    _tableView.dataSource=self;
    _tableView.mj_footer.backgroundColor = kColor(236, 236, 239);
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // 去除分割线
    // tarbar遮挡问题用下面3行代码解决
    UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame)-20, 0);
    self.tableView.contentInset = adjustForTabbarInsets;
    self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
    
    // 3.设置上拉与下拉
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownAction)];
    self.tableView.mj_header.backgroundColor = [UIColor clearColor];
    // 4.下拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpAction)];
    
    self.tableView.backgroundColor = kColor(250, 250, 250);
    //修改---这里是赋值了
    self.mainBodyArray = [[NSMutableArray alloc] init];
    //为空下拉刷新
    if([_mainBodyArray count] == 0){
        [self pullDownAction];
    }
    
    [self.view addSubview:_tableView];
    //ID
    lastID = 0;
    self.tabBarItem.title =NSLocalizedString(@"校友圈","");
//    NSString * str = [[Account shared]getStudentLongID];
//    [CirnoError ShowErrorWithText:str];
//    if ([str isEqual: @"1509853G-I011-0243"] )
//        self.tabBarItem.title = @"学神圈";

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //这个方法比初始化cell先执行所以得先设置frame
    BaseStatusCellFrame *frame = [[BaseStatusCellFrame alloc]init];
  //  CirnoLog(@"row:%ld,section:%ld",(long)indexPath.row,(long)indexPath.section);
    [frame setStatus:_mainBodyArray[indexPath.row]];
 //   NSLog(@".....%f......",[frame cellHeight]);
    return [frame cellHeight];
    
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏Navigation

    [self.tabBarController.tabBar setHidden:NO];
    //关闭滑动
//    CirnoSideBarViewController * sideBar = [CirnoSideBarViewController share];
//    sideBar.diabled = YES;
    self.tableView.userInteractionEnabled = YES;
    
    //体验第一
    _mainBodyArray = [receivceMessageLogic getDataFromCoreData];
    [self.tableView reloadData];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    NSString* page = @"MessageCircle";
    [MTA trackPageViewBegin:page];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


-(void) pullUpAction {
    [self refreshData];
    [self.tableView.mj_footer endRefreshing];
}
-(void) pullDownAction{
    [self downData];
    [self.tableView.mj_header endRefreshing];
}

-(void) refreshData{
    NSString *pushNum;
//    if (self.up){
//        CirnoLog(@"已在刷新中");
//        return;
//    }
//    self.up =YES;
    if([_mainBodyArray count] == 0){
        pushNum = @"0";
    }
    else{
        pushNum = [NSString stringWithFormat:@"%lld", _mainBodyArray[[_mainBodyArray count] - 1].ID];
    }
    
    //数据流加密
    NSDictionary *o1 =@{@"ec":@"1019",
                        @"OldestMessageID":pushNum};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    
  //  NSLog(@"%@",[data AES256_Decrypt:[HeiHei toeknNew_key]]);
   // NSLog(@"%@",data);
    
    
    //POST数据
    NSDictionary *parameters = @{@"ec":data};
    
    NSURL *URL = [NSURL URLWithString:BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //转成最原始的data,一定要加
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
        
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        //处理json
        _mainBodyArray = [receivceMessageLogic pullUpToRefresh:_mainBodyArray reciveNews:json];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
      //  self.up =NO;
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];
        [self.tableView.mj_header endRefreshing];
      //  self.up =NO;
    }];

    
}
-(void) downData{
//    CirnoLog(@"触发了下拉刷新");
//    // 上拉刷新
//    if (self.down){
//        CirnoLog(@"已在刷新中");
//        return;
//
//    }
//    self.down =YES;
    //数据流加密
    NSDictionary *o1 =@{@"ec":@"1018",
                        @"RecentMessageID":@"0"};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    
   // NSLog(@"%@",[data AES256_Decrypt:[HeiHei toeknNew_key]]);
   // NSLog(@"%@",data);
    
    
    //POST数据
    NSDictionary *parameters = @{@"ec":data};
    
    NSURL *URL = [NSURL URLWithString:BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //转成最原始的data,一定要加
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
       // NSLog(@"这边有可能会崩溃%@",result);
        if (result == nil) [CirnoError ShowErrorWithText:NSLocalizedString(@"网络错误", "")];
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        @try {

            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //处理json
            _mainBodyArray = [receivceMessageLogic pullDownToRefresh:_mainBodyArray reciveNews:json];
            [self.tableView reloadData];
        }
        @catch (NSException *exception) {
            CirnoLog(@"捕捉异常：%@,%@",exception.name,exception.reason);
        }
        @finally {
            [self.tableView.mj_header endRefreshing];
         //   self.down =NO;
        }

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];
       // [alert show];
        [self.tableView.mj_header endRefreshing];
    //    self.down =NO;
    }];

}

-(void)optionDock:(long long)ID didClickType:(DockButtonType)type{
    CirnoLog(@"点击了下方的按键");
    switch (type){
        case DockButtonTypeLike:
            CirnoLog(@"点赞操作");
            //[self like:ID];
            [self comment:ID];
            break;
        case DockButtonTypeShare:
            CirnoLog(@"分享操作");
            [self share];
            break;
        case DockButtonTypeComment:
            CirnoLog(@"评论操作");
            [self comment:ID];
        default:
            break;
        
    }
}

- (void)actionSheet:(UIActionSheet*)actionSheet didDismissWithButtonIndex:  (NSInteger)buttonIndex

{

    if(buttonIndex ==0) {
        UIImageWriteToSavedPhotosAlbum(_sentimg.image,self,
                                       @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
        
    }
    
}
- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(void*)contextInfo

{

    if(!error) {
    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"完成", "") dismissAfter:2];
    }else

    {

        NSString * message = [error localizedDescription];

        [CirnoError ShowErrorWithText:message];
        
    }
    
}
-(void) comment:(long long)ID{
    messageDetailViewController *controller = [[messageDetailViewController alloc] init];
    MainBody *PushBody;
    for(MainBody *body in _mainBodyArray){
        if (body.ID == ID){
            PushBody = body;
            break;
        }
    }
    controller.mainBody = PushBody;
    [self.navigationController pushViewController:controller animated:YES] ;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_mainBodyArray count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    _tcell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (_tcell == nil) {
        _tcell = [[StatusCell alloc]init];
        BaseStatusCellFrame *frame = [[BaseStatusCellFrame alloc]init];
        [frame setStatus:_mainBodyArray[indexPath.row]];
        [_tcell setCellFrame:frame];
    }
    _tcell.dock.delegate = self;
    _tcell.avatarDelegate = self;
    return _tcell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageDetailViewController *controller = [[messageDetailViewController alloc] init];
    NSLog(@"1");
    controller.mainBody = [_mainBodyArray objectAtIndex:indexPath.row];
    NSLog(@"2");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    //取消选中
    NSLog(@"3");
    [self.navigationController pushViewController:controller animated:YES] ;
    NSLog(@"4");
}






-(void)showWhenCommentSuccess{
    [JDStatusBarNotification showWithStatus:NSLocalizedString(@"发送成功", "") dismissAfter:2];
}


//分享
-(void) share{

 
}

#pragma mark 分享的Delegate
-(void)ClickWhichButton:(int)which{
//    if ( sender.tag == SHARE_ITEM_WEIXIN_SESSION ) {
//        [_shareButtonDelegate ClickWhichButton:0];
//
//    }else if ( sender.tag == SHARE_ITEM_WEIXIN_TIMELINE ) {
//        [_shareButtonDelegate ClickWhichButton:1];
//
//    }else if ( sender.tag == SHARE_ITEM_QQ ) {
//        [_shareButtonDelegate ClickWhichButton:2];
//        [self shareToQQ];
//
//    }else if ( sender.tag == SHARE_ITEM_QZONE ) {
//        [_shareButtonDelegate ClickWhichButton:3];
//        [self shareToQzone];
//
//    }else if ( sender.tag == SHARE_ITEM_WEIBO ) {
//        [_shareButtonDelegate ClickWhichButton:4];
//        [self shareToWeibo];
//    }
    NSLog(@"which%d",which);
//    [self.shareView clickClose];
//    if(which==0){
//
//        NSData *data = UIImageJPEGRepresentation([self screenView:self.view], 1);
//        [self.shareView shareToWeixinSessionWithImageData:data];
//    }
//    else if(which==1){
//
//        NSData *data = UIImageJPEGRepresentation([self screenView:self.view], 1);
//        [self.shareView shareImageToWeixinTimelineWithImageData:data];
//    } else if (which == 2){
//        NSData *data = UIImageJPEGRepresentation([self screenView:self.view], 1);
//        //[self.shareView ]
//    }
}

- (UIImage*)screenView:(UIView *)view{
    CGRect rect = view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
