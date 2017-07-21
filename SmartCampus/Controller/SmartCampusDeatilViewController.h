//
//  SmartCampusDeatilViewController.h
//  Currency
//
//  Created by Cirno on 03/02/2017.
//  Copyright © 2017 Umi. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Smart.h"
#import "BasicHead.h"
#import "MacauHoliday.h"
@interface SmartCampusDeatilViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) SmartPlace* places;
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSArray* week;
@property (nonatomic,strong)NSString *content;
@end
