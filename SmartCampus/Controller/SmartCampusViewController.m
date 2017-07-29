//
//  SmartCampusViewController.m
//  Currency
//
//  Created by Cirno on 12/01/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import "SmartCampusViewController.h"
#import "AFNetworking.h"
#import "SmartCampusDeatilViewController.h"
#import "CirnoError.h"
#import "MTA.h"
@interface SmartCampusViewController ()
@property (nonatomic,strong) UIButton* backbutton;
@end

@implementation SmartCampusViewController


-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _backbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, NavBarHeight-StatusBarHeight)];
  //  [_backbutton setImage:[UIImage imageNamed:@"story_back" ]forState:UIControlStateNormal];
 //   [_backbutton setImage:[UIImage imageNamed:@"story_back_pres"] forState:UIControlStateSelected];
//    [_backbutton setTitle:UIKitLocalizedString(@"Done") forState:UIControlStateNormal];
//    [_backbutton addTarget:self action:@selector(back1) forControlEvents:UIControlEventTouchDown];
//
//    [self.navigationController.navigationBar addSubview:_backbutton];
    self.navigationController.navigationBar.backgroundColor = navigationTabColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor=navigationTabColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = NSLocalizedString(@"智慧校园", "");
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", "") style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.view addSubview:_tableView];
    //NSString *content = [[NSString alloc]init];
    //1.创建队列组
    dispatch_group_t group = dispatch_group_create();
    //2.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);

        @try {
            NSString *urls = @"https://must.plus/time.json";
            NSError *error = nil;
            NSURL *url = [NSURL URLWithString:urls];
            _content = [[NSString alloc]initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
            if (_content == nil)
                [NSException raise:@"下载失败" format:@"下载失败"];
        } @catch (NSException *exception) {
            [CirnoError ShowErrorWithText:exception.description];
            [self dismissViewControllerAnimated:YES completion:nil];
        } @finally{
            if (_content!= nil){
            Smart* spc = [[Smart alloc]initWithjson:_content];
            self.data = spc;
            }
        }
        dispatch_group_leave(group);
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (_content!=nil)
        [self update];
        else
            [CirnoError ShowErrorWithText:@"下载失败"];
    });
}
-(void)update{
    [self.tableView reloadData];
}
-(void)back1{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    SmartCampusDeatilViewController * scdv = [[SmartCampusDeatilViewController alloc]init];
    scdv.places = self.data.object[section].places[row];
    _backbutton.hidden = YES;
    [self.navigationController pushViewController:scdv animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data.object[section] countOfPlaces];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.data countOfObject];
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return NSLocalizedString(self.data.object[section].desc, "");
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;

    cell.textLabel.text =NSLocalizedString(self.data.object[section].places[row].name, "");
    cell.detailTextLabel.text = self.data.object[section].places[row].desc;

    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}
@end
