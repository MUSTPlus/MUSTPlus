//
//  SearchGradeTableViewController.m
//  MUST_Plus
//
//  Created by zbc on 16/10/9.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "SearchGradeTableViewController.h"
#import "AFNetworking.h"
#import "GradeCoreDateManager.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "BasicHead.h"
#import "CirnoError.h"
#import "UIImage+CYButtonIcon.h"
#import <CYWebviewController/UIButton+WHE.h>
#import "HeiHei.h"
#import "NSString+AES.h"

@interface SearchGradeTableViewController ()

@property (nonatomic,strong) NSString *ThisYearGPA;
@property (nonatomic,strong) NSString *accumGPA;
@property (nonatomic,strong) NSMutableArray *result;
@property (nonatomic,strong) GradeCoreDateManager *gradeCoreDateManager;
@end

@implementation SearchGradeTableViewController

//
-(void)contin{

    [self setNavigation];
    self.tableView.scrollEnabled =NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableFooterView = footerView;
    [self.tabBarController.tabBar setHidden:YES];
    _result = [[NSMutableArray alloc] init];
    _gradeCoreDateManager = [[GradeCoreDateManager alloc] init];


    _result = [_gradeCoreDateManager selectData:0 andOffset:0];
    if([_result count] > 0){
        self.ThisYearGPA = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThisYearGPA"];
        self.accumGPA = [[NSUserDefaults standardUserDefaults] objectForKey:@"accumGPA"];
    }
    else{
        [self doSearch];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self contin];
}


-(void) setNavigation{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, self.view.frame.size.width,70)];
    self.navigationItem.title = @"校园";
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
    UIButton *backBtn = [UIButton buttonBackWithImage:_backIcon buttontitle:NSLocalizedString(@"返回", "")target:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [customView addSubview:backBtn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setImage:[UIImage imageNamed:@"fresh.png"] forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btn setTitle:NSLocalizedString(@"刷新", "") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;

    //[btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    UIBarButtonItem *rewardItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(fresh) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItems = @[rewardItem];

}


-(void)fresh{
    [self doSearch];
}

-(void) doSearch{
    
    //搜索前都把数据删了
    [_gradeCoreDateManager deleteData];

//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"科大网络上天中~" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alert addAction:cancelAction];
//    
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = NSLocalizedString(@"Loading", "");
    [HUD showInView:self.view];
    
    //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的账号密码!" delegate:self cancelButtonTitle:@"了解了" otherButtonTitles:nil];
    
    //数据流加密
    NSDictionary *o1 =@{@"ec":@"1011",
                        @"studentID":[[NSUserDefaults standardUserDefaults] objectForKey:@"studentID"],
                        @"password": [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    
    NSLog(@"%@",data);
    
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
            [self saveData:json[@"grade"]];
            [HUD dismiss];
        }
        else{
            [HUD dismiss];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];
     //   [self presentViewController:alert animated:YES completion:nil];
        [HUD dismiss];
    }];
    
}


-(void) saveData:(NSDictionary *)responseArray{
    NSMutableArray *a = [[NSMutableArray alloc] init];
    
    self.ThisYearGPA = [responseArray valueForKey:@"ThisYearGPA"][0];;
    self.accumGPA = [responseArray valueForKey:@"accumGPA"][0];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.ThisYearGPA forKey:@"ThisYearGPA"];
    [[NSUserDefaults standardUserDefaults] setObject:self.accumGPA forKey:@"accumGPA"];
    
    NSArray *Credit = [responseArray objectForKey:@"Credit"];
    NSArray *grade = [responseArray objectForKey:@"Grade"];
    NSArray *className = [responseArray objectForKey:@"className"];

    NSLog(@"%@",(NSString *)className[1]);
    int y = 0;
    for(int i=0;i<[[responseArray objectForKey:@"Credit"] count];i++){
        NSMutableDictionary *b = [[NSMutableDictionary alloc] init];
        [b setValue:(NSString *)Credit[i] forKey:@"credit"];
        [b setValue:(NSString *)grade[i] forKey:@"grade"];
        [b setValue:(NSString *)className[y] forKey:@"className_en"];
        y = y + 1;
        [b setValue:(NSString *)className[y] forKey:@"className_zh"];
        y = y + 1;
        [a addObject:b];
    }
    [_gradeCoreDateManager insertCoreData:a];
    
    _result = [_gradeCoreDateManager selectData:0 andOffset:0];
    [self.tableView reloadData];
}

-(void) backBtnClicked:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

//#pragma mark - Table view data source
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([_result count]!=0){
        return [_result count]+2;
    }
    else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//   
    static NSString *reusedID = @"YXCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                             reuseIdentifier:reusedID];
    }
    
    if([_result count]!=0){
        if(indexPath.row == 0){

            cell.textLabel.text = NSLocalizedString(@"总GPA", "");
            cell.detailTextLabel.text = self.accumGPA;
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.text = NSLocalizedString(@"这学期GPA", "");
            cell.detailTextLabel.text = self.ThisYearGPA;
        }
        else if(indexPath.row>=2){
            MyGrade *info = [_result objectAtIndex:indexPath.row-2];
            cell.textLabel.text = info.className_zh ;
            NSLog(@"%@",info.className_zh);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@:%@ %@:%@",NSLocalizedString(@"学分", ""),info.credit,NSLocalizedString(@"成绩", ""),info.grade];
        }
    }
    cell.userInteractionEnabled =NO;
    
    return cell;
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}


@end
