//
//  SchoolLibraryTableViewController.m
//  MUSTBEE
//
//  Created by zbc on 15/10/20.
//  Copyright © 2015年 zbc. All rights reserved.
//

#import "SchoolLibraryTableViewController.h"
#import "BCBookLibrary.h"
#import "AFNetworking.h"
#import "BCBookDetailTableViewController.h"
#import <JGProgressHUD.h>
#import "HeiHei.h"
#import "NSString+AES.h"
#import "UIImage+CYButtonIcon.h"
#import <CYWebviewController/UIButton+WHE.h>
#import "BasicHead.h"
#import "CirnoError.h"
@interface SchoolLibraryTableViewController ()
@property (nonatomic,strong) UISearchBar *SearchBar;
@property (nonatomic,strong) NSMutableArray *SearchBooks;
@end

@implementation SchoolLibraryTableViewController

CGSize *CellLabelSize;
CGFloat *point;
NSString *Item;
NSString *info;
int placeNumber;
NSMutableArray *number;
NSMutableArray *place;
NSMutableArray *state;
int CellSelect;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    
    number = [[NSMutableArray alloc] init];
    state = [[NSMutableArray alloc] init];
    place = [[NSMutableArray alloc] init];
    self.SearchBooks = [[NSMutableArray alloc] init];
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.navigationItem.title = NSLocalizedString(@"查询图书", "");
    [self.tabBarController.tabBar setHidden:YES];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableFooterView = footerView;
    
    
    
    self.SearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 30)];
    self.SearchBar.delegate = self;
    self.SearchBar.placeholder = @"";
    self.tableView.tableHeaderView = self.SearchBar;
    
    

    [self.tabBarController.tabBar setHidden:YES];

}


-(void) setNavigation{
    self.navigationController.navigationBarHidden=NO;
   // [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, self.view.frame.size.width,70)];
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

-(void) backBtnClicked:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(point != 0){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            [self.tableView setContentOffset:CGPointMake(0, *point)];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.SearchBooks.count;
}


-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.SearchBar resignFirstResponder];
    [self.SearchBooks removeAllObjects];
    
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = NSLocalizedString(@"Loading", "");
    [HUD showInView:self.view];
    
    //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的账号密码!" delegate:self cancelButtonTitle:@"了解了" otherButtonTitles:nil];
    
    //数据流加密
    NSDictionary *o1 =@{@"ec":@"1010",
                        @"Key":searchBar.text,
                        @"index": @"0"};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
   // NSString *data = secret;
    
    //POST数据
    NSDictionary *parameters = @{@"ec":data};
  //  NSURL *URL = [NSURL URLWithString:BaseURL];
    NSURL *URL = [NSURL URLWithString:BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //转成最原始的data,一定要加
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
       // NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if([json[@"state"] isEqualToString:@"1"]){
            [self handleJSON:json[@"book"]];
            [HUD dismiss];
        }
        else{
            [HUD dismiss];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];

        [HUD dismiss];
    }];
    
    
    
}



-(void) handleJSON:(id)json{
   NSDictionary *BookTitle = json[0];
   NSArray *bookTitle = [BookTitle valueForKeyPath:@"Item"];
    NSDictionary *BookInfo = json[1];
    NSArray *bookInfo = [BookInfo valueForKeyPath:@"info"];
    NSDictionary *BookplaceNumber = json[2];
    NSArray *bookPlaceNumber = [BookplaceNumber valueForKeyPath:@"placeNumber"];
    NSDictionary *BookPlace = json[3];
    NSArray *bookPlace = [BookPlace valueForKeyPath:@"place"];
    NSDictionary *BookNumber = json[4];
    NSArray *bookNumber = [BookNumber valueForKeyPath:@"number"];
    NSDictionary *BookState = json[5];
    NSArray *bookState = [BookState valueForKeyPath:@"state"];
    
    NSLog(@"%@",json);
    if(bookTitle!=nil){
        //anotherNumber针对多个藏书地点的优化
        int anotherNumber = 0;
        //提取JSON信息
        for(int i=0;i<[bookTitle count];i++){
            @try {
                Item = bookTitle[i][0];
                if([bookInfo[i] count] ==0){
                  info = @"";
                }else{
                info = bookInfo[i][0];
                }
                placeNumber = [bookPlaceNumber[i] intValue];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            for(int x=0;x<placeNumber;x++){
                [number addObject:bookPlace[anotherNumber][0]];
                [place addObject:bookNumber[anotherNumber][0]];
                [state addObject:bookState[anotherNumber][0]];
                NSLog(@"%@",bookNumber[anotherNumber][0]);
                anotherNumber++;
            }
            //图书
            BCBookLibrary *BCbook = [[BCBookLibrary alloc] init];
            [BCbook SaveData:Item BookInfo:info placeNumber:placeNumber number:number place:place state:state];
            [self.SearchBooks addObject:BCbook];
            NSLog(@"%@",Item);
            number = [[NSMutableArray alloc] init];
            state = [[NSMutableArray alloc] init];
            place = [[NSMutableArray alloc] init];
        }
        [self.tableView reloadData];
    }
    else{
        
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
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
    cell.textLabel.font = messageFont;
    cell.textLabel.text = [[self.SearchBooks objectAtIndex:indexPath.row] getItem];
    [cell.textLabel sizeToFit];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CellSelect = (int) indexPath.row;
    BCBookDetailTableViewController *NextView = [[BCBookDetailTableViewController alloc] init];
    NextView.BookDetail = [self.SearchBooks objectAtIndex:CellSelect];
    [self.navigationController pushViewController:NextView animated:YES];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}



@end
