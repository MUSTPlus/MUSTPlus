//
//  LeftViewController.m
//  LYHSideBarCtrl
//
//  Created by Charles Leo on 14-8-4.
//  Copyright (c) 2014年 Charles Leo. All rights reserved.
//

#import "LeftViewController.h"
#import "BasicHead.h"
#import "schoolTimetableViewController.h"
#import "CirnoTableDelegate.h"
#import "CirnoArrayDataSource.h"
#import "CirnoDataCell.h"
#import "SideItem.h"
#import "UserDetailsController.h"
#import "UserModel.h"
#import "SendMailTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BusStationViewController.h" //公交车页面
#import "SettingViewController.h"
#import <AFNetworking.h>
#import "Account.h"
#import "CurrencyViewController.h"
#import "SmartCampusViewController.h"
@interface LeftViewController ()
{
    CirnoArrayDataSource * _dataSource;
    CirnoTableDelegate * _delegate;
    NSInteger selectIndex;
    UIImageView * headImage;
    UIImageView * rCodeImage;
    UIImageView * bgImage;
    UILabel * nameLabel;
    UILabel * descriptionLabel;
    
}
@end

@implementation LeftViewController
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)ClickAvatar{

    //UserModel *um = [[UserModel alloc]init];
    //um = [um getUserModel:[[Account shared]getStudentLongID]];
    UserDetailsController* udc = [[UserDetailsController alloc]init];
    //udc.currentUser = um;
    udc.studID=[[Account shared]getStudentLongID];
    udc.isSelf = YES;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:udc];

   // navi.navigationBarHidden = YES;
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title = NSLocalizedString(@"返回", "");
    navi.navigationItem.backBarButtonItem=backbutton;
    //[self pushViewController:udc animated:YES];
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = sidebarBackGroundColor;
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    [self presentViewController:navi animated:YES completion:nil];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    descriptionLabel.text = [[Account shared]getWhatsup];
    nameLabel.text = [[Account shared]getNickname];
    NSURL *url = [NSURL URLWithString:[[Account shared]getAvatar]];
   // NSLog(@"%@",[[Account shared]getAvatar]);
    [headImage sd_setImageWithURL:url];
}

- (void)makeView{
    headImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 60, 55, 55)];
    headImage.clipsToBounds = YES;
    headImage.layer.borderWidth = 1.0f;
    headImage.backgroundColor = [UIColor lightGrayColor];
    headImage.userInteractionEnabled = YES;
    headImage.layer.cornerRadius = 55.0/2;
    headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    headImage.layer.borderWidth = 1.0f;
    headImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickAvatar)];
    [headImage addGestureRecognizer:singleTap1];
    //允许头像可点击
    //headImage.image = [UIImage imageNamed:@"headimage.jpg"];

    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame) + 10, headImage.frame.origin.y + 6, 100, 20)];
    nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.shadowColor=[UIColor grayColor];
    nameLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    
    
//    rCodeImage = [[UIImageView alloc]initWithFrame:CGRectMake(ContentOffset - 45, nameLabel.frame.origin.y, 25, 25)];
//    rCodeImage.backgroundColor =[UIColor clearColor];
//    rCodeImage.image = [UIImage imageNamed:@"sidebar_ QRcode_normal"];
//    
    
//    NSArray * levelImageArray = @[@"usersummary_icon_lv_crown",@"usersummary_icon_lv_sun",@"usersummary_icon_lv_sun",@"usersummary_icon_lv_moon",@"usersummary_icon_lv_star"];
//    for (int i = 0; i<levelImageArray.count; i++) {
//        UIImageView * levelImage = [[UIImageView alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x + 14 * i, CGRectGetMaxY(nameLabel.frame) + 12, 12, 12)];
//        levelImage.backgroundColor = [UIColor clearColor];
//        levelImage.image = [UIImage imageNamed:levelImageArray[i]];
//        [self.view addSubview:levelImage];
//    }
//    
    descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(headImage.frame.origin.x, CGRectGetMaxY(headImage.frame) + 6, 240, 20)];
    descriptionLabel.font = [UIFont systemFontOfSize:14.0f];
    descriptionLabel.textAlignment = NSTextAlignmentLeft;
    descriptionLabel.textColor = [UIColor whiteColor];
    descriptionLabel.shadowColor=[UIColor grayColor];
    descriptionLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    //CGRectGetMaxY(headImage.frame)
  //  bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,ContentOffset, 160)];

    bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,Width, 160)];
    //bgImage.image = [UIImage imageNamed:@"sidebar_bg.jpg"];
    bgImage.backgroundColor = sidebarBackGroundColor;
    [self.view addSubview:bgImage];
    [self.view bringSubviewToFront:descriptionLabel];
    [self.view addSubview:descriptionLabel];
    [self.view addSubview:nameLabel];
    [self.view addSubview:headImage];
    //[self.view addSubview:rCodeImage];
    UIView * containerView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgImage.frame), ContentOffset, Height - CGRectGetHeight(bgImage.frame))];
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeView];
    
    if ([self.delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
        [self.delegate leftSideBarSelectWithController: [self subControllerWithIndex:0]];
        selectIndex = 0;
    }
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgImage.frame), Width, self.view.bounds.size.height-CGRectGetMaxY(bgImage.frame)) style:UITableViewStylePlain];
    tableView.backgroundColor = sidebarBackGroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    TableViewCellConfigureBlock configureBlock = ^(CirnoDataCell *cell,SideItem * item){
        [cell configureForData:item];
    };
    
    
    NSArray * titleArray = @[NSLocalizedString(@"学生邮箱", ""),NSLocalizedString(@"公交车", ""),NSLocalizedString(@"汇率", ""),NSLocalizedString(@"智慧校园",""),NSLocalizedString(@"设置", "")];
    NSArray * iconArray = @[@"sidebar-mail",@"sidebar-bus",@"currency",@"sidebar-smartcampus",@"sidebar_setting"];

    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i< titleArray.count; i++) {
        SideItem *item = [[SideItem alloc]init];
        item.title = titleArray[i];
        item.iconName = iconArray[i];
        [array addObject:item];
    }
    _dataSource = [[CirnoArrayDataSource alloc]initWithItems:array cellItentifier:@"ID" configureCellBlock:configureBlock];
    tableView.dataSource = _dataSource;
    
    TableViewDelegateConfigureBlock delegateBlock = ^(CirnoDataCell *cell,NSIndexPath * indexPath){
        
        if ([delegate respondsToSelector:@selector(leftSideBarSelectWithController:)]) {
            
            if (indexPath.row == selectIndex) {
                [delegate leftSideBarSelectWithController:nil];
            }
            else
            {
                [delegate leftSideBarSelectWithController:[self subControllerWithIndex:indexPath.row]];
            }
        }
        selectIndex = indexPath.row;
        
        if(selectIndex == 0){
            SendMailTableViewController *controller = [[SendMailTableViewController alloc] init];
            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:passcodeNavigationController animated:YES completion:nil];
        }
        else if(selectIndex == 1){
            BusStationViewController *controller = [[BusStationViewController alloc] init];
            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:passcodeNavigationController animated:YES completion:nil];
        }
        
        else if(selectIndex == 2){
            CurrencyViewController * cvc = [[CurrencyViewController alloc]init];
            cvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:cvc];
            [self presentViewController:nc animated:YES completion:^{
            }];
        
        }
        
        else if(selectIndex == 3){
            SmartCampusViewController * scvc = [[SmartCampusViewController alloc]init];
            scvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:scvc];
            passcodeNavigationController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", "") style:UIBarButtonItemStyleDone target:nil action:nil];
            [self presentViewController:passcodeNavigationController animated:YES completion:nil];
        } else if (selectIndex == 4){
            SettingViewController * ctr = [[SettingViewController alloc]init];
            ctr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:ctr];
            [self presentViewController:passcodeNavigationController animated:YES completion:nil];
        }

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    };
    _delegate = [[CirnoTableDelegate alloc]initWithCount:array.count andHeight:60 andConfigureBlock:delegateBlock];
    tableView.delegate = _delegate;
    [self.view addSubview:tableView];
}



- (UINavigationController *)subControllerWithIndex:(NSInteger)index
{
    
    UIViewController *next  = [[UIViewController alloc] init];

    if([[Account shared]getPassword] != nil && [[Account shared]getStudentLongID] != nil){
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        next = [storyBoard instantiateViewControllerWithIdentifier:@"Root"];
    }
    else{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        next = [storyBoard instantiateViewControllerWithIdentifier:@"Login"];
    }
    
    UINavigationController * navCtrl = [[UINavigationController alloc]initWithRootViewController:next];
    navCtrl.navigationBarHidden = YES;
    return navCtrl;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
