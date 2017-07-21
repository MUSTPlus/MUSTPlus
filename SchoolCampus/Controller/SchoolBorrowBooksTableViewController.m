//
//  SchoolBorrow_Books_ArrayTableViewController.m
//  MUSTBEE
//
//  Created by zbc on 15/10/25.
//  Copyright © 2015年 zbc. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#import "SchoolBorrowBooksTableViewController.h"
#import "AFNetworking.h"
#import "MJRefreshNormalHeader.h"
#import "BorrowBooks+CoreDataClass.h"
#import "JPUSHService.h"
#import <JGProgressHUD.h>
#import "HeiHei.h"
#import "NSString+AES.h"
#import "ChangePinNumberView.h"
#import "UIImage+CYButtonIcon.h"
#import <CYWebviewController/UIButton+WHE.h>
#import "BasicHead.h"
#import "Account.h"
#import "CirnoError.h"
@interface SchoolBorrowBooksTableViewController ()

@end

@implementation SchoolBorrowBooksTableViewController{
    ChangePinNumberView *openNotifyDownView; //点击课程显示详细页面
}

- (void)showDefaultCard{
    if (!openNotifyDownView) {
        openNotifyDownView = [[ChangePinNumberView alloc] init];
    }
    [openNotifyDownView show];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.myAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self setNavigation];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.Borrow_Books_Array = [[NSMutableArray alloc] init];
    self.tableView.showsVerticalScrollIndicator = false;
    [self.tabBarController.tabBar setHidden:YES];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableFooterView = footerView;
    
    [self.Borrow_Books_Array removeAllObjects];
    self.Borrow_Books_Array = [self getBorrow_Books_Array];
    
    
    if([[Account shared]getPin] == nil){
        [self showDefaultCard];
    }
    
    
    //注册键盘出现的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setNavigation{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, self.view.frame.size.width,70)];
    self.navigationItem.title = NSLocalizedString(@"校园", "");
    UIFont *font = [UIFont fontWithName:@"yuanti" size:18];
    font = [UIFont systemFontOfSize:18];
    
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes =dic;
    self.navigationController.navigationBar.barTintColor = navigationTabColor;
    [self.navigationController.navigationBar setTranslucent:NO];
    //CYWebView里面轮子的螺丝，我把他拿出来了，简单的来说就是画个箭头
    _backIcon = [UIImage cy_backButtonIcon:[UIColor whiteColor]];
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage cy_backButtonIcon:nil] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked:)];
    
    UIView * customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton *backBtn = [UIButton buttonBackWithImage:_backIcon buttontitle:NSLocalizedString(@"返回", "") target:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [customView addSubview:backBtn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
}



-(void) loadNewData{
    [self cancelAllNotification];

    //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的账号密码!" delegate:self cancelButtonTitle:@"了解了" otherButtonTitles:nil];
    
    //数据流加密
    NSDictionary *o1 =@{@"ec":@"1009",
                        @"studentID":[[Account shared]getStudentLongID],
                        @"pin": [[Account shared]getPin]};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
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
        if([json[@"state"] isEqualToString:@"1"]){
            [self handleJSON:json[@"borrow"]];
        }
        else{
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];
    }];
    

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(void) handleJSON:(id)json{
    [self.Borrow_Books_Array removeAllObjects];
    
   // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请修改成正确pin码！" delegate:self cancelButtonTitle:@"了解了" otherButtonTitles:nil];
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:nil message:@"您没有借书信息！" delegate:self cancelButtonTitle:@"了解了" otherButtonTitles:nil];
    
    NSDictionary *BookDetail = json[0];
    NSString *IsIn = [BookDetail valueForKeyPath:@"in"];
    NSString *IsBorrow = [BookDetail valueForKeyPath:@"isBorrow"];
    
    NSLog(@"%@",BookDetail);
    
    if([IsIn isEqualToString:@"yes"]){
        if([IsBorrow isEqualToString:@"yes"]){
    NSArray *bookTitle = [BookDetail valueForKeyPath:@"title"];
    NSArray *bookDeadLine = [BookDetail valueForKeyPath:@"deadline"];
    for(int i=0;i<[bookTitle count];i++){
        BorrowBook *Book = [[BorrowBook alloc] init];
        [Book setData:bookTitle[i][0] deadLine:bookDeadLine[i][0]];
        [self.Borrow_Books_Array addObject:Book];
    }
    [self deleteData];
    [self saveBorrow_Books_Array:self.Borrow_Books_Array];
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
        }
        else{
            [alert1 show];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }
    }
    else{
        [self showDefaultCard];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *reusedID = @"YXCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:reusedID];
    }
    
    UIFont *messageFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    cell.textLabel.font = messageFont;
    cell.textLabel.text = [[self.Borrow_Books_Array objectAtIndex:indexPath.row] getTitle];
    cell.detailTextLabel.text = [[self.Borrow_Books_Array objectAtIndex:indexPath.row] getDeadline];
    return cell;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.Borrow_Books_Array count];
}

-(void) saveBorrow_Books_Array:(id)Borrow_Books_Array{
    NSError *error=nil;
    for(int i=0;i<[Borrow_Books_Array count];i++){
       BorrowBooks *BorrowBooks =[NSEntityDescription insertNewObjectForEntityForName:@"BorrowBooks" inManagedObjectContext:self.myAppDelegate.managedObjectContext];
        BorrowBooks.deadLine =  [[Borrow_Books_Array objectAtIndex:i] getDeadline];
        BorrowBooks.title =  [[Borrow_Books_Array objectAtIndex:i] getTitle];
        [self setLocalNotification:[[Borrow_Books_Array objectAtIndex:i] getDeadline]];//Notifition
        
        BOOL isSaveSuccess=[_myAppDelegate.managedObjectContext save:&error];
        if (!isSaveSuccess) {
            NSLog(@"Error:%@",error);
        }else{
            NSLog(@"Save successful!");
        }
    }
}

-(NSMutableArray*) getBorrow_Books_Array{
    NSMutableArray<BorrowBook *> *Borrow_Books_Array = [[NSMutableArray alloc] init];
    NSError* error=nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request = [NSFetchRequest fetchRequestWithEntityName:@"BorrowBooks"];
    NSMutableArray* mutableFetchResult=[[_myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    else{
        for (BorrowBooks* book in mutableFetchResult) {
            BorrowBook *Book = [[BorrowBook alloc] init];
            Book.deadline = book.deadLine;
            Book.title = book.title;
            [Borrow_Books_Array addObject:Book];
        }
    }
    return Borrow_Books_Array;
}

-(void) deleteData{
    NSError* error=nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request = [NSFetchRequest fetchRequestWithEntityName:@"BorrowBooks"];
    NSMutableArray* mutableFetchResult=[[_myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
        
    }
    else{
        for (BorrowBooks* book in mutableFetchResult) {
            [_myAppDelegate.managedObjectContext deleteObject:book];
        }
        BOOL isSaveSuccess=[_myAppDelegate.managedObjectContext save:&error];
        if (!isSaveSuccess) {
            NSLog(@"Error:%@",error);
            return;
        }else{
            NSLog(@"delete successful!");
        }
    }
}


-(void) backBtnClicked:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) setLocalNotification:(NSString *)deadLine{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *date = [deadLine substringFromIndex:4];
    NSString *day_month = [date substringToIndex:6];
    NSString *year = [date substringFromIndex:6];
    NSString *Rdate = [NSString stringWithFormat:@"%@20%@",day_month,year];
    NSString *RRdate = [Rdate substringToIndex:10];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSTimeZone *pdt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:pdt];
    NSDate *FireDate = [dateFormatter dateFromString:RRdate];
    int day = 7;
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"day"]){
        day = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"day"];
    }
    FireDate = [FireDate dateByAddingTimeInterval:-day*24*60*60];
    NSLog(@"%@",FireDate);
        UILocalNotification* localNotification = [[UILocalNotification alloc]init];
    
//改用极光推送API
    localNotification = [JPUSHService
                        setLocalNotification:FireDate
                     alertBody:@"你有一本书即将到期!"
                     badge:1
                     alertAction:nil
                     identifierKey:@"BorrowBooks"
                     userInfo:nil
                     soundName:nil];
    //  [self clearAllInput];
    NSString *result;
    if (localNotification) {
        result = @"设置本地通知成功";
    } else {
        result = @"设置本地通知失败";
    }
}

-(void) cancelAllNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}


#pragma mark 键盘方法
- (void)keyboardWasShown:(NSNotification*)aNotification

{
   // [openNotifyDownView change1];
}


-(void)keyboardWillBeHidden:(NSNotification*)aNotification

{
  //  [openNotifyDownView change2];
}


@end
#pragma clang diagnostic pop  
