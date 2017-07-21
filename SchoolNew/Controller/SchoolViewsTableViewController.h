//
//  SchoolViewsTableViewController.h
//  MUST_Plus
//
//  Created by zbc on 16/10/5.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBCBannerView.h"
#import "ZBCNavigationScrollView.h"
#import "BasicHead.h"
#import "HeaderView.h"
#import <MJRefresh.h>
#import "SchoolNewTableViewCell.h"
#import "NewsViewController.h"
#import "NSString+AES.h"
#import "HeiHei.h"
#import <AFNetworking.h>
#import "SchoolNewsLogic.h"
#import "SchoolCoreDataManagement.h"
#import "CirnoError.h"
#import "CirnoSideBarViewController.h"
#import <SafariServices/SafariServices.h>
@interface SchoolViewsTableViewController : UITableViewController<Banner,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,SchoolNavigationViewDelegate,UIViewControllerPreviewingDelegate,SFSafariViewControllerDelegate>

@property (nonatomic,strong) HeaderView *head;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) ZBCBannerView *bannerView;
@property (nonatomic,strong) ZBCNavigationScrollView *navigation;
@property int cellNumber;

@end
