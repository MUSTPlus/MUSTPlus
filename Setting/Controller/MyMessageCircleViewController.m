 //
//  MyMessageCircleViewController.m
//  MUST_Plus
//
//  Created by zbc on 17/1/7.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "MyMessageCircleViewController.h"
#import <MJRefresh.h>
#import "receiveMyMessageLogic.h"
#import "NSString+AES.h"
#import "HeiHei.h"
#import <AFNetworking.h>
#import "CirnoError.h"
#import "MyMessageDetailTableViewCell.h"
#import "Account.h"
#import "MyMessageDetailViewController.h"

@interface MyMessageCircleViewController (){
    NSMutableArray *_statusFrames;
    long long lastID; //此ID非彼ID那么就删了吧
}

@end

@implementation MyMessageCircleViewController

#pragma mark - 结束
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 1.标题
    _msgHeadView = [[MyMessageHeader alloc] initWithFrame:CGRectMake(0, 0, Width, 70)];
    _msgHeadView.myMessageDetailHeadAddButtonDelegate = self;
    [self.view addSubview:_msgHeadView];
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title = NSLocalizedString(@"返回", "");
    self.navigationController.navigationItem.backBarButtonItem=backbutton;

    // 2.TableView的初始化
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, Width, Height-NavigationBarHeight)];
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
    
    self.tableView.backgroundColor = kColor(250, 250, 250);

    [self pullDownAction];
    
    
    [self.view addSubview:_tableView];
    //ID
    lastID = 0;
    self.tabBarItem.title =NSLocalizedString(@"校友圈","");
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
    self.navigationController.navigationBarHidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    
    //体验第一
    _mainBodyArray = [receiveMyMessageLogic getDataFromCoreData];
    [self.tableView reloadData];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   }

-(void)ClickAdd:(id)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void) pullDownAction{
    [self downData];
    [self.tableView.mj_header endRefreshing];
}

-(void) downData{
    CirnoLog(@"触发了下拉刷新");
    // 上拉刷新
    
    //数据流加密
   // NSDictionary *o1 =@{@"ec":@"1036",
 //                       @"ID":[[Account shared] getStudentLongID]};
    NSDictionary *o1 =@{@"ec":@"1036",
                        @"ID":_studentID};

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
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        @try {
            
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //处理json
            _mainBodyArray = [receiveMyMessageLogic pullDownToRefresh:_mainBodyArray reciveNews:json];
            [self.tableView reloadData];
        }
        @catch (NSException *exception) {
            CirnoLog(@"捕捉异常：%@,%@",exception.name,exception.reason);
        }
        @finally {
            [self.tableView.mj_header endRefreshing];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];
        // [alert show];
        [self.tableView.mj_header endRefreshing];
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
            break;
        case DockButtonTypeComment:
            CirnoLog(@"评论操作");
            [self comment:ID];
        default:
            break;
            
    }
}

-(void) comment:(long long)ID{
    MyMessageDetailViewController *controller = [[MyMessageDetailViewController alloc] init];
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
        _tcell = [[MyMessageDetailTableViewCell alloc]init];
        BaseStatusCellFrame *frame = [[BaseStatusCellFrame alloc]init];
        [frame setStatus:_mainBodyArray[indexPath.row]];
        [_tcell setCellFrame:frame];
    }
    _tcell.dock.delegate = self;
    return _tcell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMessageDetailViewController *controller = [[MyMessageDetailViewController alloc] init];
    controller.mainBody = [_mainBodyArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    //取消选中
    [self.navigationController pushViewController:controller animated:YES] ;
}




@end
