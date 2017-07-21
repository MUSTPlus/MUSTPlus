//
//  BCBookDetailTableViewController.m
//  MUSTBEE
//
//  Created by zbc on 15/10/23.
//  Copyright © 2015年 zbc. All rights reserved.
//

#import "BCBookDetailTableViewController.h"
#import "UIImage+CYButtonIcon.h"
#import <CYWebviewController/UIButton+WHE.h>
#import "BasicHead.h"

@interface BCBookDetailTableViewController ()

@end

@implementation BCBookDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self setNavigation];
    
    
    //tarbar遮挡问题用下面3行代码解决
    UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(5.0f, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    self.tableView.contentInset = adjustForTabbarInsets;
    self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableFooterView = footView;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.BookDetail getplaceNumber]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
    return 2;
    }
    return 3;
}



-(void) setNavigation{
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, self.view.frame.size.width,70)];
    self.navigationItem.title = @"图书信息";
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *reusedID = @"YXCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:reusedID];
    }
    
    
    if(indexPath.section == 0 && indexPath.row == 0){
        UIFont *messageFont = [UIFont fontWithName:@"Helvetica" size:14.0];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
        cell.textLabel.font = messageFont;
        cell.textLabel.text = [self.BookDetail getItem];
        [cell.textLabel sizeToFit];
    }
    else if(indexPath.section == 0 && indexPath.row == 1){
        UIFont *messageFont = [UIFont fontWithName:@"Helvetica" size:14.0];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
        cell.textLabel.font = messageFont;
        [cell.textLabel sizeToFit];

        cell.textLabel.text = [self.BookDetail getBookInfo];
    }
    else if(indexPath.section>0 && indexPath.row == 0){
        cell.textLabel.text = [[self.BookDetail getPlace] objectAtIndex:indexPath.section - 1];
        NSLog(@"%@",[[self.BookDetail getPlace] objectAtIndex:indexPath.section - 1]);
    }
    else if(indexPath.section>0 && indexPath.row == 1){
        cell.textLabel.text = [[self.BookDetail getNumber] objectAtIndex:indexPath.section - 1];
    }
    else if(indexPath.section>0 && indexPath.row == 2){
            cell.textLabel.text = [[self.BookDetail getState] objectAtIndex:indexPath.section - 1];
        }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"图书信息";
    }
    return [NSString stringWithFormat:@"图书位置%ld",(long)section];
}

@end

